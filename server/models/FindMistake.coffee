mongoose = require('mongoose')

findMistakeSchema = new mongoose.Schema
    _id: String
    source: String
    submit: String
    correctSubmit: String
    user: String
    problem: String
    approved: Boolean

findMistakeSchema.methods.upsert = () ->
    # https://jira.mongodb.org/browse/SERVER-14322
    try
        @update(this, {upsert: true})
    catch
        logger.info "Could not upsert a hash"

findMistakeSchema.statics.findByProblemAndNotUser = (problem, user) ->
    FindMistake.find
        problem: problem
        user: {$ne: user}

findMistakeSchema.index({ problem : 1, user: 1 })

FindMistake = mongoose.model('FindMistake', findMistakeSchema);

export default FindMistake
