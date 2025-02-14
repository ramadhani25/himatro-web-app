DROP TABLE IF EXISTS mahasiswa_baru;
DROP TABLE IF EXISTS inventaris;
DROP TABLE IF EXISTS kegiatan;
DROP TABLE IF EXISTS parameter_keberhasilan;
DROP TABLE IF EXISTS program_kerja;
DROP TABLE IF EXISTS absensi;
DROP TABLE IF EXISTS pengurus CASCADE;
DROP TABLE IF EXISTS anggota_biasa;
DROP TABLE IF EXISTS notulensi;
DROP TABLE IF EXISTS rapat;
DROP TABLE IF EXISTS anggota_kehormatan;
DROP TABLE IF EXISTS anggota_luar_biasa;
DROP TABLE IF EXISTS penanggung_jawab;
DROP TABLE IF EXISTS jabatan;
DROP TABLE IF EXISTS divisi;
DROP TABLE IF EXISTS departemen;
DROP TABLE IF EXISTS kehadiran_sdm;
DROP TABLE IF EXISTS sdm_kaderisasi;
DROP TABLE IF EXISTS gambar;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS sessions;
DROP TABLE IF EXISTS signupdata;
DROP TABLE IF EXISTS feature_permission;
DROP TABLE IF EXISTS socmed_post_validator;
DROP TABLE IF EXISTS generic_presence_detector;
DROP TABLE IF EXISTS registered_form;

CREATE TABLE departemen (
  departemen_id VARCHAR(10) PRIMARY KEY,
  nama_departemen VARCHAR(150) NOT NULL,
  jumlah_anggota INT DEFAULT NULL,
  CHECK (jumlah_anggota >= 0)
);

CREATE TABLE divisi (
  divisi_id VARCHAR(10) PRIMARY KEY,
  nama_divisi VARCHAR(150) NOT NULL,
  jumlah_anggota INT DEFAULT NULL,
  departemen_id VARCHAR(10) REFERENCES departemen(departemen_id) NOT NULL
  CHECK(jumlah_anggota >= 0)
);

CREATE TABLE program_kerja (
  progja_id VARCHAR(10) PRIMARY KEY,
  nama_progja VARCHAR(255) NOT NULL,
  deskripsi VARCHAR(255) NOT NULL,
  presentase_pelaksanaan INT DEFAULT 0 CHECK (presentase_pelaksanaan >= 0),
  divisi_id VARCHAR(10) REFERENCES divisi(divisi_id),
  matrix BOOLEAN DEFAULT 't' NOT NULL
);

CREATE TABLE parameter_keberhasilan (
  parameter_id VARCHAR(10) PRIMARY KEY,
  progja_id VARCHAR(10) REFERENCES program_kerja(progja_id) NOT NULL,
  deskripsi VARCHAR(255) NOT NULL,
  tercapai BOOLEAN NOT NULL DEFAULT 'f',
  tanggal_tercapai DATE DEFAULT NULL
);

CREATE TABLE kegiatan (
  kegiatan_id VARCHAR(10) PRIMARY KEY,
  nama_kegiatan VARCHAR(255) NOT NULL,
  tanggal_pelaksanaan TIMESTAMPTZ NOT NULL,
  --progja_id VARCHAR(10) REFERENCES program_kerja(progja_id),
  tanggal_berakhir TIMESTAMPTZ NOT NULL -- cari cara implement default dijadiin jam 23.59
);

CREATE TABLE jabatan (
  jabatan_id CHAR(10) PRIMARY KEY,
  nama_jabatan VARCHAR(255) UNIQUE NOT NULL,
  hak INT NOT NULL
);

CREATE TABLE anggota_biasa (
  npm VARCHAR(11) PRIMARY KEY,
  nama VARCHAR(255) NOT NULL,
  no_telpon VARCHAR(25) UNIQUE DEFAULT NULL,
  email VARCHAR(255) UNIQUE DEFAULT NULL,
  no_whatsapp VARCHAR(25) UNIQUE DEFAULT NULL,
  no_telegram VARCHAR(25) UNIQUE DEFAULT NULL,
  instagram VARCHAR(255) UNIQUE DEFAULT NULL,
  jalur_masuk VARCHAR(10) DEFAULT NULL,
  hobi VARCHAR(255) DEFAULT NULL,
  keahlian VARCHAR(255) DEFAULT NULL,
  riwayat_penyakit VARCHAR(255) DEFAULT NULL,
  angkatan INT DEFAULT NULL,
  program_studi VARCHAR(30) DEFAULT NULL,
  ipk NUMERIC(3,2) DEFAULT NULL CHECK (ipk >= 0),
  alamat VARCHAR(255) DEFAULT NULL,
  tempat_lahir VARCHAR(255) DEFAULT NULL,
  tanggal_lahir DATE DEFAULT NULL,
  golongan_darah CHAR(3) DEFAULT NULL,
  data_lengkap BOOLEAN DEFAULT false 
);

CREATE TABLE pengurus (
  npm VARCHAR(11) PRIMARY KEY REFERENCES anggota_biasa(npm),
  divisi_id VARCHAR(10) REFERENCES divisi(divisi_id),
  jabatan_id CHAR(10) REFERENCES jabatan(jabatan_id)
);

CREATE TABLE inventaris (
  inventaris_id VARCHAR(10) PRIMARY KEY,
  nama_inventaris VARCHAR(255) NOT NULL,
  jumlah INT NOT NULL CHECK (jumlah >= 0),
  kondisi CHAR(1) NOT NULL,
  deskripsi VARCHAR(255) DEFAULT NULL,
  peminjam VARCHAR(255) DEFAULT NULL,
  lokasi_keberadaan VARCHAR(255) NOT NULL,
  kepemilikan CHAR(1) NOT NULL,
  tahun_perolehan INT NOT NULL
  --foto???
);

CREATE TABLE absensi (
  referensi_id VARCHAR(10),
  npm VARCHAR(11) NOT NULL,
  nama VARCHAR(255) NOT NULL, -- Default ambil dari query npm ke anggota biasa, ambil namanya
  waktu_pengisian TIMESTAMPTZ DEFAULT NULL,
  keterangan CHAR(1) DEFAULT NULL,
  alasan_izin VARCHAR(255) DEFAULT NULL,
  divisi VARCHAR(70) NOT NULL
);

CREATE TABLE mahasiswa_baru (
  npm VARCHAR(11) PRIMARY KEY,
  nama VARCHAR(255) NOT NULL,
  asal_sekolah VARCHAR(255) NOT NULL,
  program_studi CHAR(1) NOT NULL,
  no_telp VARCHAR(25) UNIQUE NOT NULL,
  alamat_email VARCHAR(255) UNIQUE NOT NULL,
  no_whatsapp VARCHAR(25) UNIQUE NOT NULL,
  media_sosial VARCHAR(255) NOT NULL,
  alamat VARCHAR(255) NOT NULL
);

CREATE TABLE notulensi (
  notulensi_id VARCHAR(10) PRIMARY KEY,
  referensi_id VARCHAR(10) NOT NULL,
  isi_notulensi TEXT NOT NULL,
  tanggal_pengisian TIMESTAMPTZ NOT NULL
);

CREATE TABLE rapat (
  rapat_id VARCHAR(10) PRIMARY KEY,
  jenis_rapat CHAR(1) NOT NULL,
  tanggal_pelaksanaan TIMESTAMPTZ NOT NULL,
  perihal_rapat VARCHAR(255) NOT NULL,
  tanggal_berakhir TIMESTAMPTZ NOT NULL --cari juga cara implemen default 3 jam setelahnya
);

CREATE TABLE anggota_luar_biasa (
  nama VARCHAR(255) NOT NULL,
  tahun_lulus INT NOT NULL,
  angkatan INT NOT NULL,
  nomor_sk VARCHAR(100) NOT NULL,
  npm VARCHAR(11) NOT NULL,
  tanggal_pengangkatan DATE NOT NULL
);

CREATE TABLE anggota_kehormatan (
  nama VARCHAR(255) NOT NULL,
  deskripsi_jasa VARCHAR(255) NOT NULL,
  nomor_sk VARCHAR(100) NOT NULL,
  tahun_lulus INT NOT NULL,
  angkatan INT NOT NULL,
  tanggal_pengangkatan DATE NOT NULL
);

CREATE TABLE penanggung_jawab (
  npm VARCHAR(11) REFERENCES pengurus(npm) NOT NULL,
  referensi_id VARCHAR(10) NOT NULL
);

CREATE TABLE sdm_kaderisasi (
  sdm_id VARCHAR(10) PRIMARY KEY,
  judul_kegiatan VARCHAR(255) NOT NULL,
  catatan VARCHAR(255) NOT NULL,
  presensi VARCHAR(10) UNIQUE NOT NULL
);

CREATE TABLE kehadiran_sdm (
  presensi VARCHAR(10) NOT NULL,
  nama VARCHAR(255) NOT NULL,
  npm VARCHAR(11) NOT NULL,
  kelas VARCHAR(4) NOT NULL,
  gambar_id VARCHAR(10) DEFAULT NULL,
  resume TEXT DEFAULT NULL
);

CREATE TABLE gambar (
  gambar_id VARCHAR(10) PRIMARY KEY,
  nama_gambar VARCHAR(50) NOT NULL
);

CREATE TABLE users (
  email VARCHAR(255) PRIMARY KEY,
  password VARCHAR(255) NOT NULL
);

CREATE TABLE sessions (
  sessionid VARCHAR(10) PRIMARY KEY,
  email VARCHAR(255) NOT NULL,
  session VARCHAR(200) UNIQUE NOT NULL,
  useragent VARCHAR(200) NOT NULL,
  expired BIGINT NOT NULL
);

CREATE TABLE signupdata (
  key VARCHAR(15) NOT NULL,
  nama VARCHAR(255) NOT NULL,
  npm VARCHAR(11) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE feature_permission (
  feature_id VARCHAR(10) PRIMARY KEY,
  permission_level SMALLINT NOT NULL
);

CREATE TABLE socmed_post_validator (
  id VARCHAR(10) PRIMARY KEY,
  post_name VARCHAR(255) NOT NULL,
  expired_at TIMESTAMPTZ NOT NULL,
  start_at TIMESTAMPTZ NOT NULL,
  keyword VARCHAR(255) NOT NULL,
  issuer VARCHAR(255) NOT NULL
);

CREATE TABLE generic_presence_detector (
  event_id VARCHAR(10) NOT NULL,
  expected_participant_id VARCHAR(11) NOT NULL,
  presence_status BOOLEAN DEFAULT 'f',
  key_data VARCHAR(255) DEFAULT NULL
);

CREATE TABLE registered_form (
  form_id VARCHAR(10) PRIMARY KEY,
  form_type VARCHAR(10) NOT NULL,
  start_at TIMESTAMPTZ NOT NULL,
  expired_at TIMESTAMPTZ NOT NULL,
  form_template VARCHAR(10) NOT NULL,
  issuer VARCHAR(11) REFERENCES pengurus(npm)
);

INSERT INTO departemen (departemen_id, nama_departemen) VALUES ('dep0000001', 'Pengurus Harian');
INSERT INTO departemen (departemen_id, nama_departemen) VALUES ('dep0000002', 'Pendidikan dan Pengembangan Diri');
INSERT INTO departemen (departemen_id, nama_departemen) VALUES ('dep0000003', 'Kaderisasi dan Pengembangan Organisasi');
INSERT INTO departemen (departemen_id, nama_departemen) VALUES ('dep0000004', 'Sosial dan Kewirausahaan');
INSERT INTO departemen (departemen_id, nama_departemen) VALUES ('dep0000005', 'Pengembangan Keteknikan');
INSERT INTO departemen (departemen_id, nama_departemen) VALUES ('dep0000006', 'Komunikasi dan Informasi');

INSERT INTO divisi (divisi_id, nama_divisi, departemen_id) VALUES ('div0000001', 'Pengurus Harian', 'dep0000001');
INSERT INTO divisi (divisi_id, nama_divisi, departemen_id) VALUES ('div0000002', 'Kaderisasi dan Pengembangan Organisasi', 'dep0000003');
INSERT INTO divisi (divisi_id, nama_divisi, departemen_id) VALUES ('div0000003', 'Pendidikan', 'dep0000002');
INSERT INTO divisi (divisi_id, nama_divisi, departemen_id) VALUES ('div0000004', 'Kerohanian', 'dep0000002');
INSERT INTO divisi (divisi_id, nama_divisi, departemen_id) VALUES ('div0000005', 'Minat dan Bakat', 'dep0000002');
INSERT INTO divisi (divisi_id, nama_divisi, departemen_id) VALUES ('div0000006', 'Sosial', 'dep0000004');
INSERT INTO divisi (divisi_id, nama_divisi, departemen_id) VALUES ('div0000007', 'Kewirausahaan', 'dep0000004');
INSERT INTO divisi (divisi_id, nama_divisi, departemen_id) VALUES ('div0000008', 'Penelitian dan Pengembangan', 'dep0000005');
INSERT INTO divisi (divisi_id, nama_divisi, departemen_id) VALUES ('div0000009', 'Pengabdian Masyarakat', 'dep0000005');
INSERT INTO divisi (divisi_id, nama_divisi, departemen_id) VALUES ('div0000010', 'Media Informasi', 'dep0000006');
INSERT INTO divisi (divisi_id, nama_divisi, departemen_id) VALUES ('div0000011', 'Hubungan Masyarakat', 'dep0000006');

INSERT INTO jabatan (jabatan_id, nama_jabatan, hak) VALUES ('jab0000001', 'Ketua Umum', 100);
INSERT INTO jabatan (jabatan_id, nama_jabatan, hak) VALUES ('jab0000002', 'Wakil Ketua', 90);
INSERT INTO jabatan (jabatan_id, nama_jabatan, hak) VALUES ('jab0000003', 'Sekertaris Umum', 80);
INSERT INTO jabatan (jabatan_id, nama_jabatan, hak) VALUES ('jab0000004', 'Wakil Sekertaris Umum', 75);
INSERT INTO jabatan (jabatan_id, nama_jabatan, hak) VALUES ('jab0000005', 'Bendahara', 60);
INSERT INTO jabatan (jabatan_id, nama_jabatan, hak) VALUES ('jab0000006', 'Wakil Bendahara', 55);
INSERT INTO jabatan (jabatan_id, nama_jabatan, hak) VALUES ('jab0000007', 'Kepala Departemen', 50);
INSERT INTO jabatan (jabatan_id, nama_jabatan, hak) VALUES ('jab0000008', 'Sekertaris Departemen', 45);
INSERT INTO jabatan (jabatan_id, nama_jabatan, hak) VALUES ('jab0000009', 'Kepala Divisi', 30);
INSERT INTO jabatan (jabatan_id, nama_jabatan, hak) VALUES ('jab0000010', 'Anggota', 1);
INSERT INTO jabatan (jabatan_id, nama_jabatan, hak) VALUES ('jab1603123', 'Super Admin', 150);

INSERT INTO feature_permission (feature_id, permission_level) VALUES ('feature001', 44); /* create absent form pengurus */
INSERT INTO feature_permission (feature_id, permission_level) VALUES ('feature002', 29); /* lihat semua kegiatan */
INSERT INTO feature_permission (feature_id, permission_level) VALUES ('feature003', 44); /* buat form socmed post validation form */
INSERT INTO feature_permission (feature_id, permission_level) VALUES ('feature004', 1);  /* isi data form socmed validation */
INSERT INTO feature_permission (feature_id, permission_level) VALUES ('feature005', 31); /* Lihat halaman admin */
INSERT INTO feature_permission (feature_id, permission_level) VALUES ('feature006', 1); /* Get and Post dynamic form data */

/*
INSERT INTO anggota_biasa (npm, nama, email, angkatan) VALUES ('1915061056', 'Lucky', 'm248r4231@dicoding.org', '2019');

INSERT INTO pengurus (npm, divisi_id, jabatan_id) VALUES ('1915061056', 'div0000001', 'jab0000001');

SELECT hak FROM jabatan WHERE jabatan_id = (SELECT jabatan_id FROM pengurus WHERE npm = (SELECT npm FROM anggota_biasa WHERE email = 'm248r4231@dicoding.org'));
*/