-- Cleanup
DROP TABLE dbo.Klient
GO

DROP TABLE dbo.Imiona
GO

DROP TABLE dbo.Nazwiska
GO

DROP TABLE dbo.Miejscowosci
GO

-- Create table
CREATE TABLE dbo.Klient (
    IdKlienta INT IDENTITY(1, 1) PRIMARY KEY
    ,Imie VARCHAR(30) NOT NULL
    ,Nazwisko VARCHAR(30) NOT NULL
    ,PESEL CHAR(11) NOT NULL
    ,NIP CHAR(13) NOT NULL
    ,Ulica VARCHAR(30) NOT NULL
    ,NrDomu VARCHAR(10) NOT NULL
    ,NrLokalu VARCHAR(10) NULL
    ,KodPocztowy CHAR(6) NOT NULL
    ,Poczta VARCHAR(30) NOT NULL
    ,Miejscowosc VARCHAR(30) NOT NULL
    ,Email VARCHAR(50) NULL
    ,Telefon VARCHAR(30) NULL
    ,DataRejestracji DATETIME NOT NULL
    )

-- Seed dictionaries
CREATE TABLE Imiona (
    Imie VARCHAR(20)
    ,Plec VARCHAR(1)
    );

BULK INSERT Imiona
FROM 'F:\Imiona.txt' WITH (
        FIELDTERMINATOR = ';'
        ,ROWTERMINATOR = '\n'
        )

CREATE TABLE Nazwiska (Nazwisko VARCHAR(30));

BULK INSERT Nazwiska
FROM 'F:\Nazwiska.txt' WITH (
        FIELDTERMINATOR = ';'
        ,ROWTERMINATOR = '\n'
        )

CREATE TABLE Miejscowosci (Miejscowosc VARCHAR(40));

BULK INSERT Miejscowosci
FROM 'F:\Miejscowosci.txt' WITH (
        FIELDTERMINATOR = ';'
        ,ROWTERMINATOR = '\n'
        )

---------------------------------------------------------------------
DECLARE @Imie VARCHAR(20);
DECLARE @Nazwisko VARCHAR(30);
DECLARE @Miejscowosc VARCHAR(40);
DECLARE @Pesel BIGINT;
DECLARE @Pesel_MAX BIGINT;
DECLARE @Pesel_MIN BIGINT
DECLARE @Nip BIGINT;
DECLARE @Nip_MAX BIGINT;
DECLARE @Nip_MIN BIGINT;
DECLARE @Ulica VARCHAR(43);
DECLARE @NrDomu VARCHAR(10);
DECLARE @NrDomu_MIN INT;
DECLARE @NrDomu_MAX INT;
DECLARE @NrLokalu VARCHAR(10);
DECLARE @NrLokalu_MIN INT;
DECLARE @NrLokalu_MAX INT;
DECLARE @KodPocztowy VARCHAR(7);
DECLARE @KodPocztowy_MIN INT;
DECLARE @KodPocztowy_MAX INT;
DECLARE @Email VARCHAR(50)
DECLARE @Telefon VARCHAR(30);
DECLARE @Telefon_MAX BIGINT;
DECLARE @Telefon_MIN BIGINT;
DECLARE @DataRejestracji DATE
DECLARE @Counter INT

SET @Counter = 0;

WHILE (@Counter < 5000)
BEGIN
    SET @Imie = (
            SELECT TOP 1 Imie
            FROM Imiona
            ORDER BY NEWID()
            )
    SET @Nazwisko = (
            SELECT TOP 1 Nazwisko
            FROM Nazwiska
            ORDER BY NEWID()
            )
    SET @Miejscowosc = (
            SELECT TOP 1 Miejscowosc
            FROM Miejscowosci
            ORDER BY NEWID()
            )
    SET @Pesel_MIN = 10000000000
    SET @Pesel_MAX = 99999999999

    SELECT @Pesel = ROUND(((@Pesel_MAX - @Pesel_MIN - 1) * RAND() + @Pesel_MIN), 0)

    SET @Nip_MIN = 1000000000000
    SET @Nip_MAX = 9999999999999

    SELECT @Nip = (ROUND(((@Nip_MAX - @Nip_MIN - 1) * RAND() + @Nip_MIN), 0))

    SET @Ulica = @Miejscowosc + 'SKA'
    SET @NrDomu_MIN = 1
    SET @NrDomu_MAX = 300

    SELECT @NrDomu = CAST(ROUND(((@NrDomu_MAX - @NrDomu_MIN - 1) * RAND() + @NrDomu_MIN), 0) AS VARCHAR(10))

    SET @NrLokalu_MIN = 1
    SET @NrLokalu_MAX = 40

    SELECT @NrLokalu = CAST(ROUND(((@NrLokalu_MAX - @NrLokalu_MIN - 1) * RAND() + @NrLokalu_MIN), 0) AS VARCHAR(10))

    SET @KodPocztowy_MIN = 100000
    SET @KodPocztowy_MAX = 999999

    SELECT @KodPocztowy = CAST(ROUND(((@KodPocztowy_MAX - @KodPocztowy_MIN - 1) * RAND() + @KodPocztowy_MIN), 0) AS VARCHAR(10))

    SELECT @KodPocztowy = (
            SELECT STUFF(@KodPocztowy, 3, 1, '-')
            )

    SET @Email = @Imie + '.' + @Nazwisko + '@gmail.com'
    SET @Telefon_MIN = 100000000
    SET @Telefon_MAX = 999999999

    SELECT @Telefon = STR(ROUND(((@Telefon_MAX - @Telefon_MIN - 1) * RAND() + @Telefon_MIN), 0))

    SET @DataRejestracji = DATEADD(d, RAND(), GETDATE())

    IF (
            NOT EXISTS (
                SELECT *
                FROM dbo.Klient
                WHERE PESEL = @Pesel
                    OR NIP = @Nip
                )
            )
    BEGIN
        INSERT INTO dbo.Klient
        VALUES (
            @Imie
            ,@Nazwisko
            ,@Pesel
            ,@Nip
            ,@Ulica
            ,@NrDomu
            ,@NrLokalu
            ,@KodPocztowy
            ,@Miejscowosc
            ,@Miejscowosc
            ,@Email
            ,@Telefon
            ,@DataRejestracji
            )

        SET @Counter = @Counter + 1;
    END
END