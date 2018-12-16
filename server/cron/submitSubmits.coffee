import SubmitProcess from '../models/SubmitProcess'
import Submit from '../models/submit'
import User from '../models/user'
import RegisteredUser from '../models/registeredUser'

import getTestSystem from '../../server/testSystems/TestSystemRegistry'
import LANGUAGES from '../../client/lib/languages'

import setDirty from '../lib/setDirty'

import logger from '../log'

makeTimeouts = () ->
    timeout = 1000
    result = []
    while true
        result.push(timeout)
        if timeout > 1000 * 60 * 60
            break
        timeout = timeout * 1.5
    return result

TIMEOUT_BY_ATTEMPT = makeTimeouts()

getLanguage = (lang) ->
    for l in LANGUAGES
        if lang == l[1]
            return l[0]
    throw "Unknown language " + lang

submitOneSubmit = (submit) ->
    submitProcess = await SubmitProcess.findById(submit._id)
    if not submitProcess
        submitProcess = new SubmitProcess
            _id: submit._id
            attempts: 0
            lastAttempt: new Date() - 1000 * 1000 * 1000
        await submitProcess.upsert()

    if submitProcess.attempts >= TIMEOUT_BY_ATTEMPT.length
        needTimeout = TIMEOUT_BY_ATTEMPT[TIMEOUT_BY_ATTEMPT.length - 1]
    else
        needTimeout = TIMEOUT_BY_ATTEMPT[submitProcess.attempts]
    if new Date() - submitProcess.lastAttempt < needTimeout
        return

    logger.info "Try submit pending submit #{submit.user} #{submit.problem} attempt #{submitProcess.attempts}"
    if submit.sourceRaw == "" or not submit.language
        logger.info "Empty source or unknown language, failing"
        submit.outcome = "Ошибка отправки, переотправьте"
        await submit.upsert()
        dirtyResults = {}
        await setDirty(submit, dirtyResults, {})
        await User.updateUser(submit.user, dirtyResults)
        return

    try
        testSystem = await getTestSystem("informatics")
        registeredUser = await RegisteredUser.findByKey(submit.user)
        await testSystem.submitWithObject(registeredUser, submit.problem, {source: submit.sourceRaw, language: getLanguage(submit.language)})
        await Submit.remove({_id: submit._id})
        dirtyResults = {}
        await setDirty(submit, dirtyResults, {})
        await User.updateUser(submit.user, dirtyResults)
        logger.info "Successfully submitted pending submit #{submit.user} #{submit.problem} attempt #{submitProcess.attempts}"
    catch e
        logger.info "Can not submit pending submit #{submit.user} #{submit.problem} attempt #{submitProcess.attempts}"
        submitProcess.attempts += 1
        submitProcess.lastAttempt = new Date()
        await submitProcess.upsert()
        dirtyResults = {}
        await setDirty(submit, dirtyResults, {})
        await User.updateUser(submit.user, dirtyResults)


submitSubmits = () ->
    pendingSubmits = await Submit.findPendingSubmits()
    await Promise.all(pendingSubmits.map(submitOneSubmit))

running = false

wrapRunning = (callable) ->
    () ->
        if running
            logger.info "Already running submitSubmits"
            return
        try
            running = true
            await callable()
        finally
            running = false

export default wrapRunning(submitSubmits)