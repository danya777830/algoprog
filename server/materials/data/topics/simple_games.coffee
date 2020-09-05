import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default simple_games = () ->
    return {
        topic: topic("Простые игры на графах", "Простые игры на графах", [
            label("<a href=\"https://e-maxx.ru/algo/games_on_graphs\">Некоторая теория на e-maxx</a>"),
            problem(202),
            problem(366),
            problem(3344),
            problem(371),
        ])
    }