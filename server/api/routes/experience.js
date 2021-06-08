const express = require('express');
const router = express.Router();

const checkAuth = require('../middleware/check-auth');

const ExperienceController = require('../controllers/experience');

router.get('/', ExperienceController.getAllExperiences);

router.post('/', ExperienceController.createOneExperience);

router.get('/:experienceId', ExperienceController.getOneExperience);

router.get('/earthquakeexp/:earthQuakeId', ExperienceController.getExperienceByEq);

router.get('/userexp/:userId', ExperienceController.getExperienceByUser);

router.patch('/:experienceId', checkAuth,  ExperienceController.updateOneExperience);

router.delete('/:experienceId', checkAuth, ExperienceController.deleteOneExperience);

module.exports = router;
