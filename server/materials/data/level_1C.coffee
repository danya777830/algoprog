import contest from "../lib/contest"
import label from "../lib/label"
import level from "../lib/level"
import page from "../lib/page"
import problem from "../lib/problem"
import topic from "../lib/topic"

module17396 = () ->
    page("Разбор задачи \"Строки в книге\" (читать только тем, кто ее решил!)", String.raw"""
        <div class="box generalbox generalboxcontent boxaligncenter clearfix"><h1>Разбор задачи "Строки в книге"</h1>
        
        <p>Первая идея, которая возникает в этой задаче -- это написать <code>N mod K</code> и <code>N div K+1</code>. Но, к сожалению, это не работает, когда <code>N</code> делится на <code>K</code>.</p>
        
        <p>Если бы в этой задаче можно было бы пользоваться условным оператором (if), то все было бы просто. Если бы эта задача была бы на реальной олимпиаде, то, конечно, так и пишите if. Но здесь в учебных целях if'ом пользоваться нельзя.</p>
        
        <p>На помощь придет следующая идея. Давайте сначала попробуем решить немного другую задачу: будем считать, что <i>всё</i>, что есть в этой задаче — строки в книге, страницы и строки на странице — <i>нумеруется с нуля</i>. (А <i>количество</i> строк на странице, конечно, как и раньше считается с 1.) Тогда, если, например, <code>K=3</code>, то на нулевой странице идут строки 0, 1, 2; на первой странице идут строки 3 4 5 и т.д. И несложно видеть, что вот как раз в этом случае достаточно просто разделить <code>N</code> на <code>K</code>; ответом будет <code>N div K</code> и <code>N mod K</code>; это работает во всех случаях.</p>
        
        <p>Теперь вернемся к нашей задаче. Нам вводится номер строки, если считать с единицы. Попробуем свести нашу задачу к той, которую мы только что решили; для этого вычтем из <code>N</code> единицу — получится номер строки в книге как если бы нумерация шла с нуля. Дальше разделим полученное число с остатком на <code>K</code> и получим правильные номер страницы и номер строки на странице, только нумерация всего всё еще идет с нуля. Прибавим к ответам 1, чтобы получить нумерацию с единицы.</p>
        
        <p>Итого решение задачи: <code>(N-1) div K + 1</code> и <code>(N-1) mod K + 1</code>.</p>
        
        <p>Вообще, это очень полезная идея — если задача плохо решается при нумерации с единицы, иногда оказывается намного проще перейти к нумерации с нуля. Особенно вот в подобных задачах, где вам явно надо делить на равные части.</p></div>
    """, {skipTree: true})

topic_15983 = () ->
    return topic("Задачи", "1В: Продвинутые задачи на арифметические операции: в них запрещается пользоваться if'ами и циклами", [
        module25368(),
        label("<br>"),
        problem({testSystem: "ejudge", contest: "2003", problem: "1", id: "2946"}),
        problem({testSystem: "codeforces", contest: "1386", problem: "C"}),
        problem(2945),
        problem(506),
        problem(534),
    ])

contest_15985 = () ->
    return contest("1В: Продвинутые задачи на условный оператор: в них запрещено пользоваться циклами и массивами", [
        problem(297),
        problem(255),
        problem(258),
        problem(38),
        problem(264),
        problem(235),
        problem(303),
        problem(481),
        problem(234),
    ])

contest_15987 = () ->
    return contest("1В: Продвинутые задачи на циклы: в них запрещается пользоваться массивами", [
        problem(227),
        problem(228),
        problem(3072),
        problem(3077),
        problem(1430),
    ])

module15986 = () ->
    page("Разбор задачи про Франциска Ксавьера (читать только тем, кто решил саму задачу!)", String.raw"""
        <div class="box generalbox generalboxcontent boxaligncenter clearfix"><h2>Разбор задачи про Франциска Ксавьера</h2>
        <p>Если вы еще не решили задачу про день святого Франциска Ксавьера из контеста "Продвинутые задачи на условный оператор", то не читайте дальше, сначала решите задачу.</p><br>
        -<br>-<br>-<br>-<br>-<br>-<br>-<br>-<br>-<br>-<br>-<br>-<br>-<br>-<br>
        <p>Как можно решать эту задачу? Конечно, можно решить тупо: прогнать цикл от года рождения до года смерти и каждый год проверить. По условию годы не превосходят 2000, поэтому такое решение вполне успеет по времени.</p>
        <p>Но это — задачи на условный оператор, поэтому решение с циклами разрешать я тут не буду. Тем более что в принципе понятно сразу, что задачу можно решить, просто сделав  немного вычислений, без циклов — так что программа будет работать очень быстро независимо от входных данных. (А решение с циклом может очень медленно работать, если годы во входных данных могут быть очень большими — например, на тесте 0 1000000000.) (Тем не менее, это все относится к нашему учебному курсу. Если бы такая задача вам попалась бы на олимпиаде, то, конечно, надо было бы просто написать цикл.)</p>
        <p>Как написать такое решение? В принципе, можно работать с данными «как есть», просто написать несколько if'ов, и в каждом сразу вычислять и считать ответ. Пример такого решения:
        </p><pre>{$mode delphi}
        var r,s:integer;
        begin
        read(r,s);
        if (s&lt;1605) then writeln(0)
        else if ((r=1605) or (r mod 10=5)) then writeln((s-r) div 10)
        else if (r&gt;1605) then
        	if (r mod 10&lt;5) then writeln((s-(r-r mod 10 +5))div 10 +1)
        	else writeln((s-(r-r mod 10 +15))div 10 +1)
        else writeln((s-1605) div 10 +1);
        end.
        </pre>
        Но такое решение писать довольно сложно (и вообще, я на 100% не уверен, что решение выше верное — оно, конечно, проходит все тесты, но я не уверен, что тесты там достаточно полные).<p></p>
        <p>Проще поступить следующим образом — и на самом деле это подход, встречающийся во многих задачах. Надо понимать, что у вас нет цели написать одну большую формулу (ну или несколько формул с разбором случаев). Компьютер способен на более сложные действия, и этим надо воспользоваться.</p>
        <p>Итак, пусть мы считали данные:
        </p><pre>s, f = map(int, input().split())</pre>
        (s и f от start и finish).
        <p></p>
        
        <p>Давайте, во-первых, сдвинем начало отсчета времени на 1605 год, т.е. вычтем из всех годов 1605:
        </p><pre>s = s - 1605
        f = f - 1605
        </pre>
        Это уже существенно упростит задачу: теперь нас интересуют года, делящиеся на 10, с этим работать намного проще, чем с годами, которые дают остаток 5 при делении на 10. Кроме того, дальше нам сравнения надо будет делать не с 1605, а с нулем, что позволяет не ошибиться с годом.<p></p>
        
        <p>Уже теперь формулы и if'ы будут проще. Но мы пойдем далее и вместо годов рождения и смерти посчитаем и будем использовать <i>первый год</i>, когда он мог коснуться мощей, и последний такой год.</p>
        <p>Как определить первый год, когда он мог коснуться мощей? Казалось бы, это первый год, кратный десяти, после года рождения. Соответствующую формулу несложно придумать:</p>
        <pre>s = s - s % 10 + 10
        </pre>
        <p>Правда, как только вы написали это выражение (или даже как только подумали про это), надо тут же подумать: а всегда ли это работает? Тут же должны возникнуть четыре соображения:</p>
        <ul>
        <li>А если s кратно 10 сразу?</li>
        <li>А если полученный год больше года смерти?</li>
        <li>А если полученный год меньше нуля?</li>
        <li>А верно ли это работает для отрицательных <code>s</code>?</li>
        </ul>
        <p>На первый вопрос ответ простой: наша формула сработает верно. Действительно, по условию в год рождения крестьянин не мог касаться мощей, поэтому если год рождения был кратен 10, то первый год, когда он мог коснуться мощей, будет на 10 лет позже — это наша формула и дает.</p>
        <p>Второй вопрос пока запомним, его рассмотрим позже; кроме того, запомним сразу, что надо будет проверить такой тест — например, тест 3 5, точнее, с учетом того, что мы вычитали 1605 из всех годов, то тест 1608 1610.</p>
        <p>Четвертый вопрос на самом деле не вопрос: в питоне взятие остатка для отрицательных чисел работает разумно (например, <code>(-3) % 10 == 7</code>, подумайте, почему это разумно). В результате если изначально было <code>s = -3</code>, то у нас получится <code>s = 0</code>, что и следовало ожидать. Вот в других языках программирования с этим надо аккуратно обойтись.</p>
        <p>И наконец третий вопрос обрабатывается легко: если полученный год меньше нуля, то на самом деле первый раз крестьянин мог коснуться мощей в нулевом году:</p>
        <pre>if s &lt; 0:
            s = 0
        </pre>
        <p>Аналогично поступим с годом смерти: нам надо определить последний год, кратный 10, который был не позже года смерти. Формула еще проще:</p>
        <pre>f = f - f % 10
        </pre>
        <p>Здесь тоже возникают те же четыре вопроса, точнее уже два вопроса, потому что с поведением остатка от деления для отрицательных чисел мы уже разобрались, а вопросы "полученный год меньше года рождения" и "полученный год меньше нуля" — это теперь одна и та же ситуация. Ее мы рассмотрим позже, а на оставшийся вопрос "если f кратно 10 сразу" ответ такой же: наш код работает правильно, т.к. в год смерти он мог коснуться мощей.</p>
        <p>Теперь мы знаем первый и последний год, когда крестьянин мог коснуться мощей. Ответ на задачу уже вычисляется совсем легко: <code>(f-s) // 10 + 1</code>, только надо не забыть те вопросы, которые мы откладывали. Несложно видеть, что они все объединяются в один <code>if f &lt; s</code>, и в итоге получаем простой вывод ответа:</p>
        <pre>if f &lt; s: 
            print(0)
        else:
            print((f-s) // 10 + 1)
        </pre>
        Вот и все. Итоговая программа:
        <pre>s, f = map(int, input().split())
        s = s - 1605
        f = f - 1605
        
        s = s - s % 10 + 10
        if s &lt; 0:
            s = 0
        
        f = f - f % 10
        
        if f &lt; s: 
            print(0)
        else:
            print((f-s) // 10 + 1)
        </pre>
        <p>Программа намного проще, чем та, что приведена в начале. Ошибки в ней искать тоже намного проще, т.к. можно проверять ее по частям; мы прекрасно понимаем, в чем физический смысл каждого куска.</p>
        <p>(В частности, если бы это был бы не питон, то у вас возникли бы обсуждаемые выше проблемы с остатками для отрицательных чисел. Например, что в c++, что в паскале получается <code>(-3) % 10 == -3</code> (c++) и <code>(-3) mod 10 == -3</code> (паскаль), поэтому коррекции <code>s</code> и <code>f</code> будут неверными. Надо такие случаи учитывать особо, но в любом случае как только вы находите такой баг, вы сразу понимаете, где он и как его исправить. В решении с кучей вложенных if'ов искать такую ошибку было бы намного сложнее.</p>
        <p>Итак, и это полезно не только в этой задаче, но и во многих других. Если вы понимаете, что задача решается формулой, не надо сразу бросаться эту формулу писать. Компьютер может сделать дополнительные действия, вы можете провести какие-то вычисления, например, упростив входные данные, или вычислив какие-нибудь дополнительные переменные, и т.д. Не бойтесь этого делать.</p>
        <p>И вторая мораль: если вы видите, что вы можете упростить входные данные к задаче, это зачастую полезно сделать. Последовательно упрощая данные, вы делаете решение проще и проще.</p></div>
    """, {skipTree: true})

contest_15984 = () ->
    return contest("1В: Продвинутые задачи на массивы", [
        problem(1456),
        problem(1228),
        problem(201),
        problem(1568),
    ])

contest_15988 = () ->
    return contest("1В: Продвинутые задачи на вещественные числа", [
        problem(3609),
        problem(3613),
        problem(3614),
        problem(3622),
        problem(74),
        problem(595),
    ])

contest_15989 = () ->
    return contest("1В: Продвинутые задачи на строки", [
        problem(107),
        problem(109),
        problem(112),
        problem(111),
        problem(723),
        problem(792),
        problem(1667),
    ])

topic_module_15982_0 = () ->
    return topic("Основы тестирования задач (без контеста)", null, [
        label("<a href=\"https://notes.algoprog.ru/testing/06_testing_main.html\">Теория по тестированию задач</a>. Вы там многое не поймете (особенно в примерах и в продвинутых методиках тестирования), но поймите хотя бы основы. в будущем, на более высоких уровнях, возвращайтесь к этому тексту."),
    ])

topic_module_21146_0 = () ->
    return topic("Вещественные числа", null, [
        label("Если вы еще не решали задачи на вещественные числа из уровня 1Б, то прочитайте там теорию и прорешайте все эти задачи. Там есть тонкости, которые обязательно надо знать."),
    ])

module25368 = () ->
    page("Про \"странные числа\" в коде", String.raw"""
        <div class="box generalbox generalboxcontent boxaligncenter clearfix"><h1>Про "странные числа" в коде</h1>
        <p>Иногда в ваших программах вам может быть нужно использовать какие-то фиксированные числа, возникающие из смысла задачи. Например, если вы решаете задачу про часы, то, скорее всего, у вас в программе появятся числа типа 60 (минут в часах) или 24 (часов в сутках). Тогда вы прямо указываете это число в программе, как, например, в задаче "Электронные часы - 1" с уровня 1А:</p>
        <pre>b = a % 60  # питон
        b := a mod 60;  // паскаль
        </pre>
        
        <p>Это абсолютно нормально. (Если вы будете потом писать серьезные большие программы, то от вас могут потребовать заводить специальные переменные-"константы" под эти числа, но сейчас речь не об этом, и в наших задачах это не обязательно.)</p>
        
        <p>Но бывает так, что в программе вам нужно какое-то число, которое вы с ходу не знаете, которое вам надо как-то вычислять. Например, вам надо в программе знать, на какой угол (сколько градусов) сдвигается минутная стрелка за одну минуту. Вряд ли вы это число назовете с ходу из головы. Зато понятно, как его считать: надо полный угол (360 градусов) поделить на 12 часов и то, что получится, поделить на 60 минут. </p>
        
        <p>Что вы в таком случае делаете? Вы берете калькулятор и на нем считаете, сколько будет <code>360/12/60</code>. Вы получаете 0.5 и прямо так и оставляете это число (0.5) прямо в коде программы:</p>
        <pre>b = a * 0.5  # питон
        b := a * 0.5;  // паскаль
        </pre>
        <p>Вот это уже неправильный подход.</p>
        
        <p>Любой язык программирования прекрасно работает как калькулятор. Поэтому не надо использовать внешний калькулятор. Просто напишите в программе прямо полностью выражение:</p>
        <pre>b = a * 360 / 12 / 60  # питон
        b := a * 360 / 12 / 60;  // паскаль
        </pre>
        
        <p>Вот так — намного лучше. Почему?</p>
        <ul>
        <li>Во-первых, так проще. Вам не надо лезть в калькулятор, считать там что-то, и вводить результат число в программу. Вы сразу тут вводите формулу, и компьютер делает работу за вас.</li>
        <li>Во-вторых, так надежнее. Вы можете случайно ввести в калькулятор не то число, или ошибиться при вводе результата в программу. Частая ситуация — если результат получается в виде длинной десятичной дроби, то вы вручную можете ввести слишком мало знаков. А компьютер посчитает за вас настолько точно, насколько он только может.</li>
        <li>Наконец, так понятнее. Если вы вернетесь к своей программе через неделю, вы вряд ли сразу вспомните, что такое 0.5 и откуда вы его взяли. А если вы увидите формулу <code>360/12/60</code>, все сразу станет понятнее, т.к. 360, 12 и 60 — вполне понятные в этой задаче числа, и скорее всего вы сразу вспомните, почему что и на что вы делили. Аналогично, программа будет понятнее для других людей, кто ее будет смотреть. Наконец, если у вас в формуле на самом деле ошибка (как простейший пример — вы разделили на 24 вместо 12), то заметить ее намного проще, чем если бы у вас в программе был только результат.</li>
        </ul>
        
        <p>Аналогичные соображения относятся и к другим ситуациям. Например, вам в программе может потребоваться код символа A. Вы можете посмотреть в таблицу символов и увидеть, что это 65. А можете написать <code>ord('A')</code>. Вот второй вариант намного лучше первого — пусть компьютер сам за вас считает, преимущества все те же, что описаны выше. Если вам надо знать, насколько коды заглавных букв отличаются от маленьких — тоже пишите формулу. И т.д.</p>
        
        <p>Вообще, общее правило:</p>
        <div style="border:1px solid black; padding: 10px;">Если вам в программе нужно использовать число, которое вы сразу называете из головы (например, количество минут в часе), то просто пишите это число. Если же вам нужно число, которые вы как-то вычисляете, то не пишите его в программе, а пишите формулу.</div></div>
    """, {skipTree: true})

export default level_1C = () ->
    return level("1В", [
        label("<p>Чтобы перейти на следующий уровень, надо решить <b>минимум половину задач</b>. Когда вы их решите, я рекомендую вам переходить на следующий уровень, чтобы не откладывать изучение новой теории. К оставшимся задачам этого уровня возвращайтесь позже время от времени и постарайтесь со временем все-таки дорешать почти все их до конца.</p>"),
        topic_module_21146_0(),
        topic_module_15982_0(),
        topic_15983(),
        module17396(),
        contest_15985(),
        module15986(),
        label("Если вы пишете на питоне, то в первых двух задачах из продвинутых задач на циклы массивами пользоваться можно — просто потому, что иначе вы не сможете считать много чисел в одной строке."),
        contest_15987(),
        contest_15984(),
        label("Две последние задачи в \"Продвинутых задачах на вещественные числа\" повторяют задачи из просто \"Задач на вещественные числа\" с уровня 1Б. Так задумано для тех, кто не решал уровень 1Б; если вы решали контест на вещественные числа на уровне 1Б, то вам пересдавать эти задачи не надо."),
        contest_15988(),
        contest_15989(),
    ])
