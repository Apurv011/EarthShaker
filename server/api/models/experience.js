const mongoose = require('mongoose');


const experienceSchema = mongoose.Schema({

    _id: mongoose.Schema.Types.ObjectId,
    earthQuakeId: { type: String, required: true },
    userName: { type: String, required: true },
    userId: { type: String, required: true },
    experience: {type: String, required: true},
    link: {type: String, required: true},
    location: {type: String, required: true},
    dayDate: {type: String, required: true},
    time: {type: String, required: true},
    magColor: {type: String, required: true},
    mag: {type: String, required: true},
    locDes: {type: String, required: true},
    lat: {type: Number, required: true},
    lon: {type: Number, required: true}
});

module.exports = mongoose.model('Experience', experienceSchema);
