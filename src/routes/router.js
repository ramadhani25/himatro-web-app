const router = require('express').Router()
//const db = require('../../db/connection')
const { getAbsentHandler } = require('../handler/getAbsentHandler')
const { postAbsentHandler } = require('../handler/postAbsentHandler')
const { createNewAbsent } = require('../handler/createNewAbsent')

router.get('/', (req, res) => {
  res.render('homePage')
}).all('/', (req, res) => {
  res.render('methodUnsupported')
})

router.get('/tentang', (req, res) => {
  res.render('underDevelopment')
}).all('/tentang', (req, res) => {
  res.render('methodUnsupported')
})

router.get('/absensi', getAbsentHandler)
  .post('/absensi', postAbsentHandler)
  .all('/absensi', (req, res) => {
    res.status(403).render('methodUnsupported')
  })

router.get('/tahap-pengembangan', (req, res) => {
  res.render('underDevelopment')
}).all('/tahap-pengembangan', (req, res) => {
  res.render('methodUnsupported')
})

router.get('/kontak', (req, res) => {
  res.render('underDevelopment')
}).all('/kontak', (req, res) => {
  res.render('methodUnsupported')
})

router.get('/login', (req, res) => {
  res.render('underDevelopment')
}).all('/login', (req, res) => {
  res.render('methodUnsupported')
})

router.get('/hei', async (req, res) => {
  const { rows } = await db.query('SELECT * FROM test')
  res.status(200).send(rows)
})

router.get('/test', createNewAbsent)

router.all('*', (req, res) => {
  res.end('maaf, halaman yang anda cari tidak ditemukan, atau metode tidak didukung:)')
})

module.exports = { router }
