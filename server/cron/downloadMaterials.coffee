request = require('request-promise-native')

import { JSDOM } from 'jsdom'

import Material from "../models/Material"

import logger from '../log'

url = 'http://informatics.mccme.ru/course/view.php?id=1135'

downloadAndParse = (href) ->
    jar = request.jar()
    page = await request
        url: href
        jar: jar
    document = (new JSDOM(page, {url: href})).window.document
    return document

finalizeMaterialsList = (materials) ->
    materials = (m for m in materials when m)
    materials = await Promise.all(materials)
    return materials

getIndent = (activity) ->
    spacers = activity.getElementsByClassName('spacer')
    indent = 0
    for s in spacers
        indent += s.width
        s.parentElement.removeChild(s)
    if indent > 0
        indent -= 20
    return indent

parseLabel = (activity, order) ->
    indent = getIndent(activity)
    material = new Material
        _id: activity.id,
        order: order
        indent: indent
        type: "label",
        title: "",
        content: activity.innerHTML,
        materials: []
    await material.upsert()
    return material

getPageContent = (href) ->
    document = await downloadAndParse(href)
    data = document.getElementById("content")
    if not data
        logger.error("Can't find content for page " + href)
        return undefined

    mod = data.getElementsByClassName('modified')
    for m in mod
        m.parentElement.removeChild(m)

    return data.innerHTML

parseResource = (activity, order) ->
    indent = getIndent(activity)
    icon = activity.firstChild
    material = undefined
    if activity.children.length != 2
        logger.error("Found resource with >2 children " + activity.innerHTML)
        return undefined
    a = activity.children[1]
    if icon.src.endsWith("pdf.gif")
        material = new Material
            _id: activity.id,
            order: order,
            type: "pdf",
            indent: indent
            content: a.href
            title: a.innerHTML,
            materials: []
    else if icon.src.endsWith("image.gif")
        material = new Material
            _id: activity.id,
            order: order,
            type: "image",
            indent: indent
            content: a.href
            title: a.innerHTML,
            materials: []
    else
        material = new Material
            _id: activity.id,
            order: order,
            type: "page",
            indent: indent
            content: await getPageContent(a.href)
            title: a.innerHTML,
            materials: []
    await material.upsert()
    return material

getProblem = (href, order) ->
    document = await downloadAndParse(href)
    data = document.getElementsByClassName("problem-statement")
    if not data
        logger.error("Can't find statement for problem " + href)
        return undefined

    re = new RegExp '.*view3.php\\?id=\\d+&chapterid=(\\d+)'
    res = re.exec href
    id = res[1]

    name = document.getElementsByTagName("title")[0]
    if not name
        logger.error("Can't find name for problem " + href)
        return undefined
    name = name.innerHTML

    text = "<h1>" + name + "</h1>"
    for tag in data
        text += "<div>" + tag.innerHTML + "</div>"

    material = new Material
        _id: "p" + id,
        order: order,
        type: "problem",
        title: name,
        content: text,
        materials: []
    await material.upsert()
    return material


getProblemsHrefsFromStatements = (href) ->
    document = await downloadAndParse(href)
    toc = document.getElementsByClassName("statements_toc_alpha")
    if toc.length > 1
        logger.error("Found several tocs in statements " + href)
        return undefined
    toc = toc[0]

    hrefs = []
    tags = toc.getElementsByTagName("a")
    for tag in tags
        if tag.href.startsWith("http://informatics.mccme.ru/mod/statements/view3.php")
            hrefs.push(tag.href)
        else
            logger.error("Strange link in statements toc: " + tag.href + " " + href)

    return hrefs

parseStatements = (activity, order) ->
    indent = getIndent(activity)
    if activity.children.length != 2
        logger.error("Found resource with >2 children " + activity.innerHTML)
        return undefined
    a = activity.children[1]

    re = new RegExp 'view.php\\?id=(\\d+)'
    res = re.exec a.href
    id = res[1]

    hrefs = await getProblemsHrefsFromStatements(a.href)
    hrefs2 = await getProblemsHrefsFromStatements(hrefs[0])
    hrefs.splice(0, 0, hrefs2[0])

    name = a.innerHTML

    materials = []
    for href, i in hrefs
        materials.push(getProblem(href, i))

    materials = await finalizeMaterialsList(materials)
    materials = [{_id: m._id, title: m.title} for m in materials]

    material = new Material
        _id: id
        order: order
        type: "contest"
        indent: indent
        title: name
        materials: materials
    await material.upsert()
    return material

parseActivity = (activity, order) ->
    if activity.classList.contains("label")
        return parseLabel(activity, order)
    else if activity.classList.contains("resource")
        return parseResource(activity, order)
    else if activity.classList.contains("statements")
        return parseStatements(activity, order)
    return undefined

getSublevel = (material) ->
    if material.type != "label"
        return undefined

    re = new RegExp '\\s*<h3>(Уровень\\s+(.*))</h3>'
    res = re.exec material.content
    if not res
        return undefined
    id = res[2]
    name = res[1]
    return
        _id: id
        name: name

splitLevel = (materials) ->
    levels = []
    currentLevel = undefined
    order = 0
    pendingMaterials = []
    for m in materials
        sublevel = getSublevel(m)
        if sublevel
            if currentLevel
                levels.push currentLevel
            currentLevel = new Material
                _id: sublevel._id
                order: order
                type: "level"
                title: sublevel.name
                materials: pendingMaterials
            order += 1
            pendingMaterials = []
        if not currentLevel
            pendingMaterials.push m
        else
            currentLevel.materials.push m
    if currentLevel
        levels.push currentLevel
    for l in levels
        console.log l.title, l.materials.length
    return levels

parseSection = (section, id) ->
    activities = section.getElementsByClassName('activity')
    materials = []

    for activity, i in activities
        materials.push(parseActivity(activity, i))
    materials = await finalizeMaterialsList(materials)
    materials = splitLevel(materials)

    for m in materials
        m.materials = [mm._id for mm in m.materials]
        await m.upsert()

    material = new Material
        _id: id
        order: id
        type: "level"
        indent: 0
        title: id
        content: ""
        materials: [m._id for m in materials]
    await material.upsert()
    return material


export default downloadMaterials = ->
    logger.info("Start downloading materials")
    document = await downloadAndParse(url)

    materials = []

    for sectionId in [1..10]
        section = document.getElementById("section-" + sectionId)
        if not section
            continue
        materials.push(parseSection(section, sectionId))

    materials = await finalizeMaterialsList(materials, ["_id"])

    mainPageMaterial = new Material
        _id: "main"
        order: 0
        type: "main"
        materials: materials
    await mainPageMaterial.upsert()

    logger.info("Done downloading materials")
