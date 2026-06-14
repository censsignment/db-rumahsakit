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




