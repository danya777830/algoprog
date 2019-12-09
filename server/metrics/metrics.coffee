import logger from '../log'
responseTime = require('response-time')

logRequest = (req, res, time) ->
    logger.info "Request to ", req.path, " user ", req.user?.informaticsId, " time=", time

PERIOD = 300

times = {}
counts = {}
totalCounts = 0
totalTime = 0
lastAccumulateTime = new Date()

accumulateRequests = (req, rs, time) ->
    if not (req.path of times)
        times[req.path] = 0
    if not (req.path of counts)
        counts[req.path] = 0
    times[req.path] += time
    counts[req.path] += 1
    totalTime += time
    totalCounts += 1
    now = new Date()
    passed = now - lastAccumulateTime
    if passed > PERIOD * 1000
        logger.info "Request statistics for #{passed/1000} s: #{totalCounts} requests, #{totalTime} time, #{totalTime / totalCounts} avg"
        for path of times
            logger.info "Request statistics for #{passed/1000} s for path #{path}: #{counts[path]} requests, #{times[path]} time, #{times[path] / counts[path]} avg"
        times = {}
        counts = {}
        totalTime = 0
        totalCounts = 0
        lastAccumulateTime = now

export default setupMetrics = (app) ->
    log = process.env["LOG_REQUESTS"]
    accumulate = process.env["ACCUMULATE_REQUESTS"]
    app.use(responseTime((req, res, time) ->
        if log then logRequest(req, res, time)
        if accumulate then accumulateRequests(req, res, time)
    ))
