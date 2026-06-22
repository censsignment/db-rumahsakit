DROP DATABASE IF EXISTS db_rumah_sakit;
CREATE DATABASE IF NOT EXISTS db_rumah_sakit;
USE db_rumah_sakit;

CREATE TABLE poli (
    id_poli VARCHAR(10) PRIMARY KEY,
    nama_poli VARCHAR(100) NOT NULL,
    lokasi VARCHAR(100) NOT NULL
);

CREATE TABLE dokter (
    id_dokter VARCHAR(10) PRIMARY KEY,
    id_poli VARCHAR(10) NOT NULL,
    nama_dokter VARCHAR(100) NOT NULL,
    spesialis VARCHAR(100) NOT NULL,

    CONSTRAINT fk_dokter_poli
    FOREIGN KEY (id_poli)
    REFERENCES poli(id_poli)
);

CREATE TABLE pasien (
    id_pasien VARCHAR(10) PRIMARY KEY,
    nama_pasien VARCHAR(100) NOT NULL,
    jenis_kelamin CHAR(1) NOT NULL,
    tgl_lahir DATE NOT NULL,
    alamat TEXT,
    no_hp_pasien VARCHAR(15),
    gol_darah VARCHAR(3)
);

CREATE TABLE jadwal (
    id_jadwal VARCHAR(10) PRIMARY KEY,
    id_dokter VARCHAR(10) NOT NULL,
    hari_praktik VARCHAR(20) NOT NULL,
    jam_mulai TIME NOT NULL,
    jam_selesai TIME NOT NULL,

    CONSTRAINT fk_jadwal_dokter
    FOREIGN KEY (id_dokter)
    REFERENCES dokter(id_dokter)
);

CREATE TABLE pendaftaran (
    id_pendaftaran VARCHAR(10) PRIMARY KEY,
    id_pasien VARCHAR(10) NOT NULL,
    id_jadwal VARCHAR(10) NOT NULL,
    tgl_daftar DATE NOT NULL,
    no_antrian INT NOT NULL,
    status_kunjungan VARCHAR(30) NOT NULL,

    CONSTRAINT fk_pendaftaran_pasien
    FOREIGN KEY (id_pasien)
    REFERENCES pasien(id_pasien),

    CONSTRAINT fk_pendaftaran_jadwal
    FOREIGN KEY (id_jadwal)
    REFERENCES jadwal(id_jadwal)
);

CREATE TABLE rekam_medis (
    id_rekam_medis VARCHAR(10) PRIMARY KEY,
    id_pendaftaran VARCHAR(10) NOT NULL,
    id_dokter VARCHAR(10) NOT NULL,
    keluhan TEXT,
    hasil_pemeriksaan TEXT,
    tgl_pemeriksaan DATE NOT NULL,

    CONSTRAINT fk_rekam_pendaftaran
    FOREIGN KEY (id_pendaftaran)
    REFERENCES pendaftaran(id_pendaftaran),

    CONSTRAINT fk_rekam_dokter
    FOREIGN KEY (id_dokter)
    REFERENCES dokter(id_dokter)
);

CREATE TABLE diagnosa (
    id_diagnosa VARCHAR(10) PRIMARY KEY,
    id_rekam_medis VARCHAR(10) NOT NULL,
    diagnosa VARCHAR(255) NOT NULL,
    keterangan TEXT,

    CONSTRAINT fk_diagnosa_rekam
    FOREIGN KEY (id_rekam_medis)
    REFERENCES rekam_medis(id_rekam_medis)
);

CREATE TABLE obat (
    id_obat VARCHAR(10) PRIMARY KEY,
    nama_obat VARCHAR(100) NOT NULL,
    harga_obat DECIMAL(12,2) NOT NULL
);

CREATE TABLE resep (
    id_resep VARCHAR(10) PRIMARY KEY,
    id_rekam_medis VARCHAR(10) NOT NULL,
    id_obat VARCHAR(10) NOT NULL,
    dosis VARCHAR(100),
    jumlah INT,
    aturan VARCHAR(255),

    CONSTRAINT fk_resep_rekam
    FOREIGN KEY (id_rekam_medis)
    REFERENCES rekam_medis(id_rekam_medis),

    CONSTRAINT fk_resep_obat
    FOREIGN KEY (id_obat)
    REFERENCES obat(id_obat)
);

CREATE TABLE vital (
    id_vital VARCHAR(10) PRIMARY KEY,
    id_rekam_medis VARCHAR(10) NOT NULL,
    tekanan_darah VARCHAR(20),
    berat_badan DECIMAL(5,2),

    CONSTRAINT fk_vital_rekam
    FOREIGN KEY (id_rekam_medis)
    REFERENCES rekam_medis(id_rekam_medis)
);

CREATE INDEX idx_pasien_nama
ON pasien(nama_pasien);

CREATE INDEX idx_dokter_nama
ON dokter(nama_dokter);

CREATE INDEX idx_obat_nama
ON obat(nama_obat);

USE db_rumah_sakit;
-- =====================================
-- TABEL POLI
-- =====================================
INSERT INTO poli (id_poli, nama_poli, lokasi)
VALUES
('POL01', 'Umum', 'Gedung A Lantai 1'),
('POL02', 'Penyakit Dalam', 'Gedung C Lantai 2'),
('POL03', 'Bedah', 'Gedung D Lantai 3'),
('POL04', 'Gigi dan Mulut', 'Gedung E Lantai 1');


-- =====================================
-- TABEL DOKTER
-- =====================================
INSERT INTO dokter (id_dokter, id_poli, nama_dokter, spesialis)
VALUES
('D01', 'POL01', 'dr. Andi Wirawan', 'Dokter Umum'),
('D02', 'POL01', 'dr. Siti Rahayu', 'Dokter Umum'),
('D03', 'POL02', 'dr. Hendra Prasetyo, Sp.PD', 'Spesialis Penyakit Dalam'),
('D04', 'POL03', 'dr. Rizky Firmansyah, Sp.B', 'Spesialis Bedah'),
('D05', 'POL04', 'drg. Fajar Nugroho, Sp.KG', 'Spesialis Konservasi Gigi'),
('D06', 'POL02', 'dr. Lina Marlina, Sp.PD', 'Spesialis Penyakit Dalam');


-- =====================================
-- TABEL PASIEN
-- =====================================
INSERT INTO pasien (id_pasien, nama_pasien, jenis_kelamin, tgl_lahir, alamat, no_hp_pasien, gol_darah)
VALUES
('PA01', 'Ahmad Fauzi', 'L', '1990-01-01', 'Jl. Merdeka No. 12, Purwokerto', '82100000001', 'A'),
('PA02', 'Sari Indah Lestari', 'P', '1985-03-02', 'Jl. Sudirman No. 5, Purwokerto', '82100000002', 'B'),
('PA03', 'Rina Wulandari', 'P', '1978-07-04', 'Jl. Ahmad Yani No. 7, Cilacap', '82100000004', 'AB'),
('PA04', 'Lilis Suryani', 'P', '1980-11-06', 'Jl. Pemuda No. 19, Purwokerto', '82100000006', 'B'),
('PA05', 'Eko Nugroho', 'L', '1988-01-13', 'Jl. Veteran No. 23, Banyumas', '82100000007', 'O'),
('PA06', 'Hasan Basri', 'L', '1975-03-17', 'Jl. Pahlawan No. 15, Cilacap', '82100000009', 'A'),
('PA07', 'Sri Handayani', 'P', '1970-08-27', 'Jl. Kalimantan No. 21, Cilacap', '82100000014', 'O'),
('PA08', 'Dian Permata', 'P', '1986-06-01', 'Jl. Cempaka No. 22, Purwokerto', '82100000019', 'B'),
('PA09', 'Andi Saputro', 'L', '1990-12-04', 'Jl. Elang No. 8, Purwokerto', '82100000022', 'B'),
('PA11', 'Nita Anggraeni', 'P', '1984-06-14', 'Jl. Flamingo No. 3, Banjarnegara', '82100000023', 'A'),
('PA12', 'Bambang Supriadi', 'L', '1992-08-16', 'Jl. Garuda No. 12, Purbalingga', '82100000024', 'B'),
('PA13', 'Lis Setyawati', 'P', '1972-10-18', 'Jl. Hasanudin No. 9, Banyumas', '82100000025', 'O'),
('PA14', 'Muhammad Arif', 'L', '1976-05-03', 'Jl. Anggrek No. 4, Purwokerto', '82100000026', 'B'),
('PA15', 'Ratna Dewi', 'P', '1988-07-22', 'Jl. Melati No. 10, Cilacap', '82100000027', 'A'),
('PA16', 'Hendra Saputra', 'L', '1989-07-30', 'Jl. Kamboja No. 7, Banyumas', '82100000028', 'O'),
('PA17', 'Yusuf Maulana', 'L', '1963-07-03', 'Jl. Cemara No. 15, Purwokerto', '82100000029', 'B'),
('PA18', 'Indah Permatasari', 'P', '1986-05-03', 'Jl. Teratai No. 5, Purbalingga', '82100000030', 'AB'),
('PA19', 'Siti Nurjanah', 'P', '1987-12-15', 'Jl. Rajawali No. 8, Cilacap', '82100000031', 'A'),
('PA20', 'Fajar Ramadhan', 'L', '1993-01-27', 'Jl. Kenari No. 11, Banyumas', '82100000032', 'B'),
('PA21', 'Desi Kartika', 'P', '1994-09-03', 'Jl. Mangga No. 18, Purwokerto', '82100000033', 'O'),
('PA22', 'Rudi Hartono', 'L', '1996-07-29', 'Jl. Merpati No. 6, Banjarnegara', '82100000034', 'A'),
('PA23', 'Wulan Kartika', 'P', '1990-03-19', 'Jl. Dahlia No. 14, Cilacap', '82100000035', 'B'),
('PA24', 'Agung Prasetyo', 'L', '1985-02-27', 'Jl. Flamboyan No. 9, Banyumas', '82100000036', 'O'),
('PA25', 'Maya Lestari', 'P', '1992-04-14', 'Jl. Sakura No. 7, Purwokerto', '82100000037', 'A');


-- =====================================
-- TABEL OBAT
-- =====================================
INSERT INTO obat (id_obat, nama_obat, harga_obat)
VALUES
('OB01', 'Paracetamol 500mg', 2000),
('OB02', 'Vitamin C 500mg', 1000),
('OB03', 'Cetirizine 10mg', 4000),
('OB05', 'Omeprazole 20mg', 7500),
('OB06', 'Amlodipine 5mg', 5500),
('OB07', 'Amoxicillin 500mg', 5000),
('OB08', 'Metformin 500mg', 3000);


-- =====================================
-- TABEL JADWAL
-- =====================================
INSERT INTO jadwal (id_jadwal, id_dokter, hari_praktik, jam_mulai, jam_selesai)
VALUES
('JAD01', 'D01', 'Senin', '08:00:00', '12:00:00'),
('JAD02', 'D02', 'Selasa', '08:00:00', '12:00:00'),
('JAD03', 'D04', 'Rabu', '07:00:00', '12:00:00'),
('JAD04', 'D03', 'Senin', '10:00:00', '15:00:00'),
('JAD05', 'D05', 'Selasa', '08:00:00', '12:00:00'),
('JAD06', 'D02', 'Kamis', '08:00:00', '12:00:00'),
('JAD07', 'D03', 'Senin', '10:00:00', '15:00:00'),
('JAD08', 'D06', 'Selasa', '08:00:00', '13:00:00'),
('JAD09', 'D03', 'Senin', '10:00:00', '15:00:00'),
('JAD10', 'D03', 'Senin', '10:00:00', '15:00:00'),
('JAD11', 'D02', 'Rabu', '11:00:00', '12:00:00'),
('JAD12', 'D01', 'Kamis', '10:00:00', '12:00:00'),
('JAD13', 'D05', 'Selasa', '13:00:00', '14:00:00'),
('JAD14', 'D03', 'Senin', '08:00:00', '12:00:00'),
('JAD15', 'D03', 'Rabu', '07:00:00', '09:00:00'),
('JAD16', 'D01', 'Kamis', '08:00:00', '11:00:00'),
('JAD17', 'D04', 'Rabu', '09:00:00', '10:00:00'),
('JAD18', 'D06', 'Selasa', '07:00:00', '10:00:00'),
('JAD19', 'D03', 'Senin', '09:00:00', '11:00:00'),
('JAD20', 'D01', 'Kamis', '08:00:00', '13:00:00'),
('JAD21', 'D02', 'Selasa', '09:00:00', '11:00:00'),
('JAD22', 'D04', 'Rabu', '08:00:00', '12:00:00'),
('JAD23', 'D03', 'Senin', '09:00:00', '11:00:00'),
('JAD24', 'D01', 'Kamis', '08:00:00', '12:00:00'),
('JAD25', 'D06', 'Selasa', '09:00:00', '14:00:00');


-- =====================================
-- TABEL PENDAFTARAN
-- =====================================
INSERT INTO pendaftaran (id_pendaftaran, id_pasien, id_jadwal, tgl_daftar, no_antrian, status_kunjungan)
VALUES
('PE01', 'PA01', 'JAD01', '2026-01-06', 1, 'Selesai'),
('PE02', 'PA02', 'JAD02', '2026-01-07', 1, 'Selesai'),
('PE03', 'PA03', 'JAD03', '2026-01-05', 1, 'Selesai'),
('PE04', 'PA04', 'JAD04', '2026-01-07', 1, 'Selesai'),
('PE05', 'PA05', 'JAD05', '2026-01-06', 1, 'Selesai'),
('PE06', 'PA06', 'JAD06', '2026-01-08', 1, 'Selesai'),
('PE07', 'PA07', 'JAD07', '2026-01-12', 2, 'Selesai'),
('PE08', 'PA08', 'JAD08', '2026-01-13', 3, 'Selesai'),
('PE09', 'PA09', 'JAD09', '2026-01-19', 3, 'Selesai'),
('PE10', 'PA03', 'JAD10', '2026-01-05', 1, 'Selesai'),
('PE11', 'PA11', 'JAD11', '2026-01-20', 3, 'Selesai'),
('PE12', 'PA12', 'JAD12', '2026-01-20', 2, 'Selesai'),
('PE13', 'PA13', 'JAD13', '2026-01-20', 2, 'Selesai'),
('PE14', 'PA14', 'JAD14', '2026-01-21', 1, 'Selesai'),
('PE15', 'PA15', 'JAD15', '2026-01-21', 2, 'Selesai'),
('PE16', 'PA16', 'JAD16', '2026-01-22', 1, 'Selesai'),
('PE17', 'PA17', 'JAD17', '2026-01-22', 2, 'Selesai'),
('PE18', 'PA18', 'JAD18', '2026-01-23', 1, 'Selesai'),
('PE19', 'PA19', 'JAD19', '2026-01-23', 2, 'Selesai'),
('PE20', 'PA20', 'JAD20', '2026-01-24', 1, 'Selesai'),
('PE21', 'PA21', 'JAD21', '2026-01-24', 2, 'Selesai'),
('PE22', 'PA22', 'JAD22', '2026-01-25', 1, 'Selesai'),
('PE23', 'PA23', 'JAD23', '2026-01-25', 2, 'Selesai'),
('PE24', 'PA24', 'JAD24', '2026-01-26', 1, 'Selesai'),
('PE25', 'PA25', 'JAD25', '2026-01-26', 2, 'Selesai');


-- =====================================
-- TABEL REKAM_MEDIS
-- =====================================
INSERT INTO rekam_medis (id_rekam_medis, id_pendaftaran, id_dokter, keluhan, hasil_pemeriksaan, tgl_pemeriksaan)
VALUES
('RM01', 'PE01', 'D01', 'Demam tinggi sejak 3 hari, sakit kepala', 'Suhu 38.9°C, tenggorokan merah', '2026-01-06'),
('RM02', 'PE02', 'D02', 'Batuk berdahak 2 minggu, sesak ringan', 'Ronki paru kiri, suhu 37.5°C', '2026-01-07'),
('RM04', 'PE03', 'D03', 'Nyeri dada, mudah lelah, sering pusing', 'TD 150/95, GDS 180 mg/dL', '2026-01-05'),
('RM06', 'PE04', 'D04', 'Nyeri perut kanan bawah, mual, demam ringan', 'Nyeri tekan McBurney positif, lekositosis', '2026-01-07'),
('RM07', 'PE05', 'D05', 'Gigi berlubang bawah kanan, nyeri berdenyut', 'Karies profunda gigi 46, pulpa terbuka', '2026-01-06'),
('RM09', 'PE06', 'D02', 'Kontrol gula darah, obat habis', 'GDA 210 mg/dL, TD normal, kontrol DM', '2026-01-08'),
('RM14', 'PE07', 'D03', 'Batuk kronis 3 minggu, keringat malam, turun BB', 'Suhu subfebris, ronki halus puncak paru', '2026-01-12'),
('RM19', 'PE08', 'D06', 'Sering pusing, tegang di leher, sulit tidur', 'TD 160/100, diagnosis hipertensi grade II', '2026-01-13'),
('RM22', 'PE09', 'D03', 'Kontrol rutin DM dan hipertensi, obat hampir habis', 'GDA 185 mg/dL, TD 140/90', '2026-01-19'),
('RM10', 'PE10','D03','Nyeri dada, mudah lelah, sering pusing (kunjungan ke-2)','TD 148/90, GDS 175 mg/dL, terkontrol sebagian','2026-01-12'),
('RM23', 'PE11', 'D02', 'Pilek berulang sejak sebulan, sering bersin pagi', 'Mukosa hidung edema, sekret jernih', '2026-01-20'),
('RM24', 'PE12', 'D01', 'Sakit tenggorokan dan demam', 'Tonsil membesar dan hiperemis', '2026-01-20'),
('RM25', 'PE13', 'D05', 'Sakit gigi geraham bawah, gusi bengkak', 'Perikoronitis gigi 38', '2026-01-20'),
('RM26', 'PE14', 'D03', 'Sering haus dan sering BAK', 'GDS 220 mg/dL', '2026-01-21'),
('RM27', 'PE15', 'D03', 'Batuk dan pilek sejak 5 hari', 'Faring hiperemis', '2026-01-21'),
('RM28', 'PE16', 'D01', 'Pusing dan lemas', 'Hb sedikit rendah', '2026-01-22'),
('RM29', 'PE17', 'D04', 'Benjolan kecil di punggung', 'Lipoma ukuran 2 cm', '2026-01-22'),
('RM30', 'PE18', 'D06', 'Nyeri ulu hati', 'Mukosa lambung iritasi', '2026-01-23'),
('RM31', 'PE19', 'D03', 'Sakit kepala dan tengkuk tegang', 'TD 155/95', '2026-01-23'),
('RM32', 'PE20', 'D01', 'Demam dan batuk kering', 'Suhu 38°C', '2026-01-24'),
('RM33', 'PE21', 'D02', 'Sesak ringan dan batuk malam', 'Hiperreaktivitas bronkus', '2026-01-24'),
('RM34', 'PE22', 'D04', 'Luka robek di tangan', 'Luka bersih 3 cm', '2026-01-25'),
('RM35', 'PE23', 'D03', 'Kontrol diabetes', 'GDS 170 mg/dL', '2026-01-25'),
('RM36', 'PE24', 'D01', 'Flu dan nyeri otot', 'Suhu 37.8°C', '2026-01-26'),
('RM37', 'PE25', 'D06', 'Nyeri lambung dan mual', 'Tenderness epigastrium', '2026-01-26');


-- =====================================
-- TABEL DIAGNOSA
-- =====================================
INSERT INTO diagnosa (id_diagnosa, id_rekam_medis, diagnosa, keterangan)
VALUES
('DI01', 'RM01', 'ISPA', '–'),
('DI02', 'RM02', 'Bronkitis Akut', 'Perlu antibiotik'),
('DI03', 'RM04', 'Diabetes Mellitus Tipe 2', 'GDS 180 mg/dL, baru terdiagnosis'),
('DI05', 'RM06', 'Suspect Appendisitis Akut', 'Perlu pemeriksaan penunjang segera'),
('DI06', 'RM07', 'Karies Dentis Profunda Gigi 46', 'Pulpa terbuka, perlu PSA'),
('DI07', 'RM09', 'Diabetes Mellitus Tipe 2', 'Kontrol rutin, GDA 210 mg/dL'),
('DI09', 'RM14', 'Suspect Tuberkulosis Paru', 'Gejala klinis dan foto thorax mendukung'),
('DI10', 'RM19', 'Hipertensi Grade II', 'TD 160/100, perlu terapi kombinasi'),
('DI12', 'RM04', 'Diabetes Mellitus Tipe 2', 'Kontrol ulang – evaluasi terapi'),
('DI13', 'RM04', 'Hipertensi Grade I', 'TD membaik, lanjut Amlodipine'),
('DI14', 'RM23', 'Rhinitis Alergi', 'Diduga dipicu debu rumah'),
('DI15', 'RM24', 'Tonsilitis Akut', 'Infeksi bakteri ringan'),
('DI17', 'RM25', 'Perikoronitis Gigi 38', 'Perlu pembersihan area gigi'),
('DI19', 'RM26', 'Diabetes Mellitus Tipe 2', 'GDS meningkat'),
('DI20', 'RM26', 'Hipertensi Grade I', 'TD sedikit meningkat'),
('DI21', 'RM27', 'ISPA', 'Infeksi saluran napas atas'),
('DI23', 'RM28', 'Anemia Ringan', 'Diduga kurang asupan zat besi'),
('DI24', 'RM29', 'Lipoma', 'Jinak, observasi'),
('DI25', 'RM30', 'Gastritis Akut', 'Keluhan kambuh'),
('DI27', 'RM31', 'Hipertensi Grade I', 'Perlu kontrol rutin'),
('DI29', 'RM32', 'ISPA', 'Infeksi ringan'),
('DI31', 'RM33', 'Asma Bronkial Ringan', 'Kondisi stabil'),
('DI32', 'RM34', 'Vulnus Laceratum', 'Perlu perawatan luka'),
('DI34', 'RM35', 'Diabetes Mellitus Tipe 2', 'Kondisi membaik'),
('DI35', 'RM36', 'Influenza', 'Gejala ringan'),
('DI37', 'RM37', 'Gastritis Akut', 'Perlu pengaturan pola makan'),
('DI39', 'RM22', 'Diabetes Mellitus Tipe 2', 'Terkontrol, lanjut obat rutin'),
('DI40', 'RM22', 'Hipertensi Grade I', 'TD 140/90, terkontrol');


-- =====================================
-- TABEL RESEP
-- =====================================
INSERT INTO resep (id_resep, id_rekam_medis, id_obat, dosis, jumlah, aturan)
VALUES
('RES01', 'RM01', 'OB01', '500mg 3x sehari', 10, 'Sesudah makan'),
('RES02', 'RM02', 'OB02', '500mg 1x sehari', 7, 'Sesudah makan pagi'),
('RES03', 'RM04', 'OB01', '500mg 3x sehari', 15, 'Sesudah makan'),
('RES04', 'RM04', 'OB01', '5mg 1x sehari malam', 5, 'Malam sebelum tidur'),
('RES05', 'RM06', 'OB03', '5mg 1x sehari malam', 5, 'Malam sebelum tidur'),
('RES06', 'RM07', 'OB08', '500mg 3x sehari', 30, 'Sesudah makan'),
('RES07', 'RM09', 'OB05', '20mg 2x sehari', 14, 'Sebelum makan'),
('RES08', 'RM09', 'OB08', '500mg 3x sehari', 15, 'Sesudah makan'),
('RES09', 'RM14', 'OB01', '500mg 3x sehari', 10, 'Sesudah makan'),
('RES10', 'RM19', 'OB01', '500mg 3x sehari', 15, 'Sesudah makan'),
('RES11', 'RM19', 'OB06', '10mg 1x sehari malam', 10, 'Malam sesudah makan'),
('RES12', 'RM04', 'OB08', '500mg 3x sehari', 30, 'Sesudah makan'),
('RES13', 'RM04', 'OB06', '5mg 1x sehari malam', 10, 'Malam sebelum tidur'),
('RES14', 'RM23', 'OB02', '500mg 1x sehari', 10, 'Sesudah makan'),
('RES15', 'RM24', 'OB07', '500mg 3x sehari', 15, 'Sesudah makan'),
('RES16', 'RM24', 'OB01', '500mg 3x sehari', 10, 'Sesudah makan'),
('RES17', 'RM25', 'OB01', '500mg 3x sehari', 10, 'Sesudah makan'),
('RES18', 'RM25', 'OB07', '500mg 3x sehari', 10, 'Sesudah makan'),
('RES19', 'RM26', 'OB08', '500mg 3x sehari', 30, 'Sesudah makan'),
('RES20', 'RM26', 'OB06', '5mg 1x sehari', 30, 'Pagi'),
('RES21', 'RM27', 'OB01', '500mg 3x sehari', 10, 'Sesudah makan'),
('RES22', 'RM27', 'OB02', '500mg 1x sehari', 10, 'Pagi'),
('RES23', 'RM28', 'OB02', '500mg 1x sehari', 14, 'Sesudah makan'),
('RES24', 'RM29', 'OB01', '500mg 3x sehari', 10, 'Sesudah makan'),
('RES25', 'RM30', 'OB01', '500mg 3x sehari', 10, 'Sesudah makan'),
('RES26', 'RM30', 'OB05', '20mg 2x sehari', 14, 'Sebelum makan'),
('RES27', 'RM31', 'OB06', '5mg 1x sehari', 30, 'Pagi'),
('RES28', 'RM31', 'OB01', '500mg 3x sehari', 10, 'Sesudah makan'),
('RES29', 'RM32', 'OB01', '500mg 3x sehari', 10, 'Sesudah makan'),
('RES30', 'RM32', 'OB02', '500mg 1x sehari', 10, 'Pagi'),
('RES31', 'RM33', 'OB02', '500mg 1x sehari', 10, 'Sesudah makan'),
('RES32', 'RM34', 'OB01', '500mg 3x sehari', 10, 'Sesudah makan'),
('RES33', 'RM34', 'OB07', '500mg 3x sehari', 10, 'Sesudah makan'),
('RES34', 'RM35', 'OB08', '500mg 3x sehari', 30, 'Sesudah makan'),
('RES35', 'RM36', 'OB01', '500mg 3x sehari', 10, 'Sesudah makan'),
('RES36', 'RM36', 'OB02', '500mg 1x sehari', 10, 'Pagi'),
('RES37', 'RM37', 'OB05', '20mg 2x sehari', 14, 'Sebelum makan'),
('RES38', 'RM37', 'OB01', '500mg 3x sehari', 10, 'Sesudah makan'),
('RES39', 'RM22', 'OB07', '500mg 3x sehari', 15, 'Sesudah makan'),
('RES40', 'RM22', 'OB06', '5mg 1x sehari', 30, 'Pagi sebelum makan');


-- =====================================
-- TABEL VITAL
-- =====================================
INSERT INTO vital (id_vital, id_rekam_medis, tekanan_darah, berat_badan)
VALUES
('VIT01', 'RM01', '120/80', 70.0),
('VIT02', 'RM02', '118/78', 58.5),
('VIT03', 'RM04', '150/95', 82.0),
('VIT05', 'RM07', '115/75', 68.0),
('VIT06', 'RM09', '125/82', 79.0),
('VIT07', 'RM14', '118/76', 52.0),
('VIT08', 'RM19', '160/100', 64.0),
('VIT09', 'RM22', '140/90', 83.0),
('VIT10', 'RM23', '120/80', 56.0),
('VIT11', 'RM24', '118/78', 72.0),
('VIT12', 'RM25', '130/80', 60.0),
('VIT13', 'RM26', '145/90', 85.0),
('VIT14', 'RM27', '120/80', 58.0),
('VIT15', 'RM28', '118/76', 68.0),
('VIT16', 'RM29', '120/80', 75.0),
('VIT17', 'RM30', '120/80', 61.0),
('VIT18', 'RM31', '155/95', 67.0),
('VIT19', 'RM32', '120/80', 70.0),
('VIT20', 'RM33', '120/78', 59.0),
('VIT21', 'RM34', '120/80', 78.0),
('VIT22', 'RM35', '135/85', 73.0),
('VIT23', 'RM36', '118/78', 76.0),
('VIT24', 'RM37', '120/80', 57.0);

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

-- =====================================================
-- VIEW 1: view_riwayat_pasien
-- =====================================================

CREATE VIEW view_riwayat_pasien AS
SELECT 
    p.id_pasien,
    p.nama_pasien,
    p.jenis_kelamin,
    p.gol_darah,
    rm.id_rekam_medis,
    rm.keluhan,
    rm.hasil_pemeriksaan,
    rm.tgl_pemeriksaan,
    d.diagnosa,
    d.keterangan AS keterangan_diagnosa,
    o.nama_obat,
    r.dosis,
    r.jumlah AS jumlah_obat,
    r.aturan,
    dok.nama_dokter,
    dok.spesialis,
    po.nama_poli,
    po.lokasi AS lokasi_poli
FROM pasien p
JOIN pendaftaran pf ON p.id_pasien = pf.id_pasien
JOIN rekam_medis rm ON pf.id_pendaftaran = rm.id_pendaftaran
LEFT JOIN diagnosa d ON rm.id_rekam_medis = d.id_rekam_medis
LEFT JOIN resep r ON rm.id_rekam_medis = r.id_rekam_medis
LEFT JOIN obat o ON r.id_obat = o.id_obat
JOIN dokter dok ON rm.id_dokter = dok.id_dokter
JOIN poli po ON dok.id_poli = po.id_poli;

SELECT * FROM view_riwayat_pasien
WHERE id_pasien = 'PA01';
-- =====================================================
-- VIEW 2: view_laporan_harian
-- =====================================================

CREATE VIEW view_laporan_harian AS
SELECT 
    pf.tgl_daftar AS tanggal,
    po.nama_poli,
    d.nama_dokter,
    COUNT(DISTINCT pf.id_pendaftaran) AS jumlah_pasien,
    COUNT(DISTINCT rm.id_rekam_medis) AS jumlah_rekam_medis,
    COUNT(DISTINCT di.id_diagnosa) AS jumlah_diagnosa,
    COUNT(DISTINCT r.id_resep) AS jumlah_resep,
    COUNT(DISTINCT r.id_obat) AS jumlah_jenis_obat,
    ROUND(SUM(r.jumlah * o.harga_obat), 0) AS total_nilai_resep,
    ROUND(AVG(v.berat_badan), 1) AS rata_rata_berat_badan_pasien
FROM pendaftaran pf
JOIN jadwal j ON pf.id_jadwal = j.id_jadwal
JOIN dokter d ON j.id_dokter = d.id_dokter
JOIN poli po ON d.id_poli = po.id_poli
LEFT JOIN rekam_medis rm ON pf.id_pendaftaran = rm.id_pendaftaran
LEFT JOIN diagnosa di ON rm.id_rekam_medis = di.id_rekam_medis
LEFT JOIN resep r ON rm.id_rekam_medis = r.id_rekam_medis
LEFT JOIN obat o ON r.id_obat = o.id_obat
LEFT JOIN vital v ON rm.id_rekam_medis = v.id_rekam_medis
GROUP BY pf.tgl_daftar, po.nama_poli, d.nama_dokter
ORDER BY pf.tgl_daftar DESC, jumlah_pasien DESC;

SELECT * FROM view_laporan_harian;

USE db_rumah_sakit; 
DELIMITER //
CREATE PROCEDURE riwayat_pasien(
    IN p_id_pasien VARCHAR(10)
)
BEGIN
    SELECT
        p.nama_pasien,
        rm.tgl_pemeriksaan,
        rm.keluhan,
        rm.hasil_pemeriksaan,
        dg.diagnosa
    FROM pasien p
    JOIN pendaftaran pd
        ON p.id_pasien = pd.id_pasien
    JOIN rekam_medis rm
        ON pd.id_pendaftaran = rm.id_pendaftaran
    LEFT JOIN diagnosa dg
        ON rm.id_rekam_medis = dg.id_rekam_medis
    WHERE p.id_pasien = p_id_pasien;
END //
DELIMITER ;
CALL riwayat_pasien('PA20');

-- PERSIAPAN: Buat tabel AUDIT LOG terlebih dahulu

CREATE TABLE IF NOT EXISTS audit_log (
    id_audit INT AUTO_INCREMENT PRIMARY KEY,
    nama_tabel VARCHAR(50) NOT NULL,
    aksi VARCHAR(20) NOT NULL, -- INSERT, UPDATE, DELETE
    id_data VARCHAR(50) NOT NULL, -- ID dari data yang berubah
    data_lama TEXT,
    data_baru TEXT,
    username VARCHAR(100) NOT NULL,
    waktu TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- TRIGGER tr_audit_pasien


DELIMITER //

-- TRIGGER untuk INSERT (tambah data pasien baru)
CREATE TRIGGER tr_audit_pasien_insert
AFTER INSERT ON pasien
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (nama_tabel, aksi, id_data, data_baru, username)
    VALUES (
        'pasien',
        'INSERT',
        NEW.id_pasien,
        CONCAT('nama: ', NEW.nama_pasien, 
               ', JK: ', NEW.jenis_kelamin,
               ', tgl_lahir: ', NEW.tgl_lahir,
               ', alamat: ', NEW.alamat,
               ', no_hp: ', NEW.no_hp_pasien,
               ', gol_darah: ', NEW.gol_darah),
        USER()
    );
END//

-- TRIGGER untuk UPDATE (ubah data pasien)
CREATE TRIGGER tr_audit_pasien_update
AFTER UPDATE ON pasien
FOR EACH ROW
BEGIN
    -- Catat perubahan data lama ke baru
    INSERT INTO audit_log (nama_tabel, aksi, id_data, data_lama, data_baru, username)
    VALUES (
        'pasien',
        'UPDATE',
        NEW.id_pasien,
        CONCAT('nama: ', OLD.nama_pasien, 
               ', JK: ', OLD.jenis_kelamin,
               ', tgl_lahir: ', OLD.tgl_lahir,
               ', alamat: ', OLD.alamat,
               ', no_hp: ', OLD.no_hp_pasien,
               ', gol_darah: ', OLD.gol_darah),
        CONCAT('nama: ', NEW.nama_pasien, 
               ', JK: ', NEW.jenis_kelamin,
               ', tgl_lahir: ', NEW.tgl_lahir,
               ', alamat: ', NEW.alamat,
               ', no_hp: ', NEW.no_hp_pasien,
               ', gol_darah: ', NEW.gol_darah),
        USER()
    );
END//

DELIMITER //
-- TRIGGER untuk DELETE (hapus data pasien)
CREATE TRIGGER tr_audit_pasien_delete
AFTER DELETE ON pasien
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (nama_tabel, aksi, id_data, data_lama, username)
    VALUES (
        'pasien',
        'DELETE',
        OLD.id_pasien,
        CONCAT('nama: ', OLD.nama_pasien, 
               ', JK: ', OLD.jenis_kelamin,
               ', tgl_lahir: ', OLD.tgl_lahir,
               ', alamat: ', OLD.alamat,
               ', no_hp: ', OLD.no_hp_pasien,
               ', gol_darah: ', OLD.gol_darah),
        USER()
    );
END//

DELIMITER ;

INSERT INTO pasien (id_pasien, nama_pasien, jenis_kelamin, tgl_lahir, alamat, no_hp_pasien, gol_darah)
VALUES ('PA26', 'Conrad Fisher', 'L', '2000-01-01', 'Jl. Gunung Muria', '08822222220', 'O');
SELECT * FROM audit_log;

UPDATE pasien SET nama_pasien = 'Jeremiah Fisher' WHERE id_pasien = 'PA26';
SELECT * FROM audit_log;

DELETE FROM pasien WHERE id_pasien = 'PA26';
SELECT * FROM audit_log;

-- FUNCTION 1 : MENGHITUNG USIA PASIEN
DELIMITER //

CREATE FUNCTION fn_hitung_usia(p_tgl_lahir DATE)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    -- Deklarasi variabel untuk menyimpan hasil usia
    DECLARE v_usia INT;
    
    -- Jika tanggal lahir NULL, kembalikan NULL
    IF p_tgl_lahir IS NULL THEN
        RETURN NULL;
    END IF;
    
    -- Hitung usia dalam tahun
    -- Rumus: Tahun sekarang - tahun lahir, 
    --        tapi sesuaikan jika belum ulang tahun tahun ini
    SET v_usia = YEAR(CURDATE()) - YEAR(p_tgl_lahir);
    
    -- Kurangi 1 jika belum melewati hari ulang tahun di tahun ini
    IF DATE_ADD(p_tgl_lahir, INTERVAL v_usia YEAR) > CURDATE() THEN
        SET v_usia = v_usia - 1;
    END IF;
    
    -- Kembalikan hasil usia
    RETURN v_usia;
    
END //

DELIMITER ;

-- Contoh : Cari pasien (usia > 20 tahun)
SELECT 
    nama_pasien,
    tgl_lahir,
    fn_hitung_usia(tgl_lahir) AS usia
FROM pasien
WHERE fn_hitung_usia(tgl_lahir) > 20;


-- FUNCTION 2 : MENGHITUNG TOTAL BIAYA OBAT
DROP FUNCTION IF EXISTS fn_total_biaya_obat;

DELIMITER //

CREATE FUNCTION fn_total_biaya_obat(p_id_rekam_medis VARCHAR(10))
RETURNS DECIMAL(12,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(12,2);
    
    -- Jumlahkan semua harga obat dikali jumlah
    SELECT COALESCE(SUM(r.jumlah * o.harga_obat), 0)
    INTO v_total
    FROM resep r
    JOIN obat o ON r.id_obat = o.id_obat
    WHERE r.id_rekam_medis = p_id_rekam_medis;
    
    RETURN v_total;
END //

DELIMITER ;

SELECT 
    rm.id_rekam_medis,
    p.nama_pasien,
    fn_total_biaya_obat(rm.id_rekam_medis) AS total_biaya_obat
FROM rekam_medis rm
JOIN pendaftaran pf ON rm.id_pendaftaran = pf.id_pendaftaran
JOIN pasien p ON pf.id_pasien = p.id_pasien;