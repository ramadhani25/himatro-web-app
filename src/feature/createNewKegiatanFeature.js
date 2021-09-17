require('dotenv').config()

const { referensiIdGenerator } = require('../util/generator')
const { validateAbsentRefData } = require('../util/validator')
const { QueryError } = require('../classes/QueryError')
const { generateErrorEmail } = require('../util/email')

const {
  createNewAbsent,
  createNewKegiatan
} = require('../util/createNewAbsent')

const createNewKegiatanFeature = async (req, res) => {
  const validate = absentRefValidator(req)

  if (!validate) {
    res.status(400).json({ errorMessage: 'Data Kegiatan / Rapat Invalid' })
    return
  }

  res.status(201).json({ successMessage: `Data diterima, permintaan anda sedang diproses. Silahkan refresh halaman admin untuk melihat ID absesi dari kegiatan yang telah anda buat.` })

  try {
    const refId = referensiIdGenerator('keg')
    await createNewAbsentRecord(refId, req.body)
  } catch (e) {
    console.log(e)
    await generateErrorEmail(`Failed to create new absent record. issuer ${req.email} recently`)
  }
}

const absentRefValidator = (req) => {
  if (!validateAbsentRefData(req.body)) return false

  return true
}

const createNewAbsentRecord = async (refId, data) => {
  try {
    const kegiatanData = {
      namaKegiatan: data.namaKegiatan,
      mulai: `${data.tanggalPelaksanaan} ${data.jamPelaksanaan}`,
      akhir: `${data.tanggalBerakhir} ${data.jamBerakhir}`
    }

    await createNewAbsent(refId)
    await createNewKegiatan(refId, kegiatanData)
  } catch(e) {
    console.log(e)
    if (e instanceof QueryError) {
      throw new QueryError('failed to create new absent record')
    }
  }
}

module.exports = { createNewKegiatanFeature }
