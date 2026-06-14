-- 3 QUERY Sederhana
-- Menampilkan seluruh data pasien
SELECT *
FROM pasien;
-- Menampilkan daftar dokter spesialis penyakit dalam
SELECT id_dokter, nama_dokter
FROM dokter
WHERE spesialis LIKE '%Penyakit Dalam%';
-- Menampilkan obat dengan harga di atas 4.000
SELECT nama_obat, harga_obat
FROM obat
WHERE harga_obat > 4000;

-- 4 QUERY (Join minimal 3 tabel)
-- Data pendaftaran pasien beserta dokter yang menangani
SELECT
p.nama_pasien,
d.nama_dokter,
pd.tgl_daftar,
pd.no_antrian
FROM pendaftaran pd
JOIN pasien p
ON pd.id_pasien = p.id_pasien
JOIN jadwal j
ON pd.id_jadwal = j.id_jadwal
JOIN dokter d
ON j.id_dokter = d.id_dokter;

-- Riwayat pemeriksaan pasien
SELECT
p.nama_pasien,
d.nama_dokter,
rm.keluhan,
rm.hasil_pemeriksaan,
rm.tgl_pemeriksaan
FROM rekam_medis rm
JOIN pendaftaran pd
ON rm.id_pendaftaran = pd.id_pendaftaran
JOIN pasien p
ON pd.id_pasien = p.id_pasien
JOIN dokter d
ON rm.id_dokter = d.id_dokter;

-- Resep obat yang diberikan kepada pasien
SELECT
p.nama_pasien,
o.nama_obat,
r.jumlah,
r.dosis
FROM resep r
JOIN obat o
ON r.id_obat = o.id_obat
JOIN rekam_medis rm
ON r.id_rekam_medis = rm.id_rekam_medis
JOIN pendaftaran pd
ON rm.id_pendaftaran = pd.id_pendaftaran
JOIN pasien p
ON pd.id_pasien = p.id_pasien;

-- Dokter dan poli tempat praktik
SELECT
d.nama_dokter,
d.spesialis,
p.nama_poli,
j.hari_praktik
FROM dokter d
JOIN poli p
ON d.id_poli = p.id_poli
JOIN jadwal j
ON d.id_dokter = j.id_dokter;

-- QUERY (SUBQUERY)
-- Pasien yang pernah berobat lebih dari 1 kali
SELECT nama_pasien
FROM pasien
WHERE id_pasien IN (
SELECT id_pasien
FROM pendaftaran
GROUP BY id_pasien
HAVING COUNT(*) > 1
);
-- QUERY (CTE)
-- Jumlah kunjungan tiap dokter
WITH kunjungan_dokter AS (
SELECT
id_dokter,
COUNT(*) AS total_kunjungan
FROM rekam_medis
GROUP BY id_dokter
)
SELECT
d.nama_dokter,
k.total_kunjungan
FROM kunjungan_dokter k
JOIN dokter d
ON k.id_dokter = d.id_dokter;

-- QUERY (GROUP BY + HAVING)
-- Dokter yang menangani lebih dari 3 pasien
SELECT
d.nama_dokter,
COUNT(*) AS jumlah_pasien
FROM rekam_medis rm
JOIN dokter d
ON rm.id_dokter = d.id_dokter
GROUP BY d.nama_dokter
HAVING COUNT(*) > 3;
