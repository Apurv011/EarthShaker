const mongoose = require('mongoose');
const Experience = require('../models/experience');

exports.getAllExperiences = (req, res, next) => {
	Experience
		.find()
		.exec()
		.then(experiences => {
			const response = {
				count: experiences.length,
				experiences: experiences.map(experience => {
					return {
						_id: experience._id,
						earthQuakeId: experience.earthQuakeId,
						userName: experience.userName,
						userId: experience.userId,
						experience: experience.experience,
						link: experience.link,
						location: experience.location,
						dayDate: experience.dayDate,
						time: experience.time,
						magColor: experience.magColor,
						locDes: experience.locDes,
						mag: experience.mag,
						lat: experience.lat,
						lon: experience.lon
					}
				})
			};
			res.status(200).json(response);
		})
		.catch(error => {
			next(error);
		})
};

exports.createOneExperience = (req, res, next) => {
	const experience = createExperience(req)
	experience
		.save()
		.then(experience => {
			res.status(200).json({
				message: 'Experience Shared Successfully!',
				experience: {
					_id: experience._id,
					earthQuakeId: experience.earthQuakeId,
					userName: experience.userName,
					userId: experience.userId,
					experience: experience.experience,
					link: experience.link,
					location: experience.location,
					dayDate: experience.dayDate,
					time: experience.time,
					magColor: experience.magColor,
					locDes: experience.locDes,
					mag: experience.mag,
					lat: experience.lat,
					lon: experience.lon
				}
			});
		})
		.catch(error => {
			console.log(error);
			next(error);
		});
};

exports.getOneExperience = (req, res, next) => {
	const id = req.params.experienceId;
	Experience
		.findById(id)
		.select('_id earthQuakeId userName userId experience link location dayDate time locDes magColor mag lat lon')
		.exec()
		.then(experience => {
			if (experience) {
				res.status(200).json(experience);
			}
			else {
				res.status(404).json({
					message: 'Experience Not Found!'
				});
			}
		})
		.catch(error => {
			next(error);
		});
};

exports.getExperienceByEq = (req, res, next) => {
	const earthQuakeId = req.params.earthQuakeId;

	Experience
		.find({earthQuakeId: earthQuakeId})
		.select('_id earthQuakeId userName userId experience link location dayDate time locDes magColor mag lat lon')
		.exec()
		.then(experience => {
			if (experience) {
				res.status(200).json(experience);
			}
			else {
				res.status(404).json({
					message: 'Experience Not Found!'
				});
			}
		})
		.catch(error => {
			next(error);
		});
};

exports.getExperienceByUser = (req, res, next) => {
	const userId = req.params.userId;

	Experience
		.find({userId: userId})
		.select('_id earthQuakeId userName userId experience link location dayDate time locDes magColor mag lat lon')
		.exec()
		.then(experience => {
			if (experience) {
				res.status(200).json(experience);
			}
			else {
				res.status(404).json({
					message: 'Experience Not Found!'
				});
			}
		})
		.catch(error => {
			next(error);
		});
};

exports.updateOneExperience = (req, res, next) => {
	const experienceId = req.params.experienceId;
	Experience
		.update({ _id: experienceId }, { $set: req.body })
		.exec()
		.then(result => {
			res.status(200).json({
				message: 'Updated Experience Successfully!',
				result: result
			});
		})
		.catch(error => {
			next(error);
		})
};

exports.deleteOneExperience = (req, res, next) => {
	const experienceId = req.params.experienceId;
	Experience
			.remove({ _id: experienceId })
			.exec()
			.then(result => {
					return res.status(200).json({
							message: 'Deleted Experience!',
							result: result
					});
			})
			.catch(error => {
					next(error);
			});
};

function createExperience(req) {
	return new Experience({
		_id: new mongoose.Types.ObjectId(),
		earthQuakeId: req.body.earthQuakeId,
		userName: req.body.userName,
		userId: req.body.userId,
		experience: req.body.experience,
		link: req.body.link,
		location: req.body.location,
		dayDate: req.body.dayDate,
		time: req.body.time,
		locDes: req.body.locDes,
		magColor: req.body.magColor,
		mag: req.body.mag,
		lat: req.body.lat,
		lon: req.body.lon
		});
}
