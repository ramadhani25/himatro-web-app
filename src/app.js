const express = require('express')
const ejs = require('ejs')
const { router } = require('./routes/router')
const { incomingRequestLogger } = require('./logger/incomingRequestLogger')

const app = express()
app.set('view engine', 'ejs')
app.use(express.static('./public'))
app.use(express.urlencoded({ extended: false }))
app.use(express.json())
app.use(express.json({ type: 'application/json' }))
app.use('/', incomingRequestLogger)
app.use('/', router)

module.exports = { app }
