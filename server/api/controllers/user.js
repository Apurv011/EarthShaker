const mongoose = require('mongoose');
const bcrypt = require('bcrypt-nodejs');
const jwt = require('jsonwebtoken');

const User = require('../models/user');

exports.signUp = (req, res, next) => {
    User
        .find({ email: req.body.email })
        .exec()
        .then(user => {
            if (user.length < 1) {
                var salt = bcrypt.genSaltSync(10)
                return bcrypt.hash(req.body.password, salt, null, (err, hash) => {
                    if (err) {
                        console.log(err)
                        return res.status(500).json({
                            error: err
                        });
                    } else {
                        const user = new User({
                            _id: new mongoose.Types.ObjectId(),
                            email: req.body.email,
                            password: hash,
                            name: req.body.name,
                        });
                        user
                            .save()
                            .then(result => {
                                console.log(result);
                                res.status(201).json({
                                    message: "User created"
                                });
                            })
                            .catch(err => {
                                console.log(err);
                                res.status(500).json({
                                    error: err
                                });
                            });
                    }
                });
            }
            const error = new Error();
            error.message = 'User Exists!';
            throw error;
        })
        .catch((error) => {
            console.log(error)
        });
};

exports.logIn = (req, res, next) => {
    let email = undefined, userId = undefined;
    User
        .find({ email: req.body.email })
        .exec()
        .then(user => {
            if (user.length < 1) {
                return res.status(404).json({
                    errror: "No user found!"
                });
            }
            email = user[0].email;
            userId = user[0]._id;
            return bcrypt.compare(req.body.password, user[0].password, function (err, result) {
                if (err) {
                    return res.status(401).json({
                        message: "Auth failed"
                    });
                }
                if (result) {
                    const token = jwt.sign(
                        {
                            email: email,
                            userId: userId
                        },
                        process.env.JWT_KEY,
                        {
                            expiresIn: "365d"
                        }
                    );
                    return res.status(200).json({
                        message: 'Auth Successful!',
                        token: token,
                        user: user[0],
                    });
                }
                return res.status(401).json({
                    message: "Invalid email or password"
                });
            });
        })
        .catch(error => {
            next(error);
        });
};

exports.deleteUser = (req, res, next) => {
    const userId = req.params.userId;
    User
        .remove({ _id: userId })
        .exec()
        .then(result => {
            res.status(200).json({
                message: 'User Deleted Successfully!'
            });
        })
        .catch(error => {
            error.message = 'Could Not Delete User!';
            next(error);
        });
};

exports.getOneUser = (req, res, next) => {
    const userId = req.params.userId;
    User
        .findById(userId)
        .select('_id email name')
        .exec()
        .then(result => {
            if(!result){
                return res.status(404).json({
                    error: 'User not found',
                });
            }
            return res.status(200).json({
                user: result,
            });
        })
        .catch(err => {
            return res.status(500).json({
                error: err,
            });
        });
}

exports.editUser = (req, res, next) => {
    const userId = req.params.userId;
      User
          .update({ _id: userId }, { $set: req.body })
          .exec()
          .then(updatedUser => {
              res.status(200).json({
          message: 'Updated User Successfully!',
          user: updatedUser
        });
          })
          .catch(err => {
              next(err);
          });
}
