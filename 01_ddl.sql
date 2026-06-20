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