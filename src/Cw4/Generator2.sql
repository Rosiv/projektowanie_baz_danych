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

WHILE (@Counter < 5)
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

DROP PROCEDURE RandomDate
GO

-- Faktury
-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:        <Author,,Name>
-- Create date: <Create Date,,>
-- Description:    <Description,,>
-- =============================================
CREATE PROCEDURE RandomDate
    -- Add the parameters for the stored procedure here
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- First, let's declare the date range. I am declaring this
    -- here for the demo, but this could be done anyway you like.
    DECLARE @date_from DATETIME;
    DECLARE @date_to DATETIME;

    -- Set the start and date dates. In this case, we are using
    -- the month of october, 2006.
    SET @date_from = '2006-10-01';
    SET @date_to = '2006-10-30';

    -- Select random dates.
    SELECT (
            -- Remember, we want to add a random number to the
            -- start date. In SQL we can add days (as integers)
            -- to a date to increase the actually date/time
            -- object value.
            @date_from + (
                -- This will force our random number to be GTE 0.
                ABS(
                    -- This will give us a HUGE random number that
                    -- might be negative or positive.
                    CAST(CAST(NewID() AS BINARY (8)) AS INT))
                -- Our random number might be HUGE. We can't have
                -- exceed the date range that we are given.
                -- Therefore, we have to take the modulus of the
                -- date range difference. This will give us between
                -- zero and one less than the date range.
                %
                -- To get the number of days in the date range, we
                -- can simply substrate the start date from the
                -- end date. At this point though, we have to cast
                -- to INT as SQL will not make any automatic
                -- conversions for us.
                CAST((@date_to - @date_from) AS INT)
                )
            )
END
GO

CREATE TABLE dbo.FakturaVAT (
    IdFaktury INT IDENTITY(1, 1) PRIMARY KEY
    ,NrFaktury VARCHAR(12) NOT NULL
    ,Nabywca INT CONSTRAINT FK_Faktura_Klient REFERENCES dbo.Klient(IdKlienta) NOT NULL
    ,FormaPlatnosci VARCHAR(20) NOT NULL
    ,DataWystawienia DATETIME NOT NULL
    ,DataSprzedazy DATETIME NOT NULL
    ,Zaplacono MONEY NOT NULL
    ,TerminZaplaty DATETIME NULL
    )
GO

---create table dane (lp int identity(1,1), nazwa nvarchar(30), flaga int default 0)
---insert into dane (nazwa,flaga) values ('1',1),('2',1),('3',1),('4',1),('5',1)
DECLARE @InvoiceCounter INT
DECLARE @NrFaktury INT
DECLARE @KlientId INT

DECLARE reader SCROLL CURSOR
FOR
SELECT IdKlienta
FROM dbo.Klient
FOR READ ONLY

OPEN reader;

FETCH NEXT
FROM reader
INTO @KlientId;

SET @NrFaktury = 1

WHILE @@FETCH_STATUS = 0
BEGIN
    -- PRINT @KlientId;
    -- IF @I % 2 =0 UPDATE dane SET flaga=0 WHERE lp = @I
    SET @InvoiceCounter = 0

    WHILE (@InvoiceCounter < 3)
    BEGIN
        DECLARE @FormaPlatnosci VARCHAR(14)

        SET @FormaPlatnosci = (
                SELECT str
                FROM (
                    SELECT 0 AS id
                        ,'sposob_platnosci' AS str
                    
                    UNION ALL
                    
                    SELECT 1
                        ,'gotówka'
                    
                    UNION ALL
                    
                    SELECT 2
                        ,'karta kredytowa'
                    
                    UNION ALL
                    
                    SELECT 3
                        ,'przelew online'
                    
                    UNION ALL
                    
                    SELECT 4
                        ,'pro forma'
                    ) x
                WHERE id = floor(rand() * 5)
                )

        DECLARE @DataWystawienia DATETIME
        DECLARE @DataSprzedazy DATETIME
        DECLARE @TerminZaplaty DATETIME

        EXEC @DataWystawienia = RandomDate

        SET @DataSprzedazy = DATEADD(day, - 1, @DataWystawienia)
        SET @TerminZaplaty = DATEADD(day, 14, @DataWystawienia)

        DECLARE @Zaplacono_MIN INT
        DECLARE @Zaplacono_MAX INT
        DECLARE @Zaplacono INT

        SET @Zaplacono_MIN = 1
        SET @Zaplacono_MAX = 1000000

        SELECT @Zaplacono = ROUND(((@Zaplacono_MAX - @Zaplacono_MIN - 1) * RAND() + @Zaplacono_MIN), 0)

        --IF (
        --        NOT EXISTS (
        --            SELECT *
        --            FROM dbo.FakturaVAT
        --            WHERE NrFaktury = @NrFaktury
        --            )
        --        )
        --BEGIN
        INSERT INTO dbo.FakturaVAT
        VALUES (
            @NrFaktury
            ,@KlientId
            ,@FormaPlatnosci
            ,@DataWystawienia
            ,@DataSprzedazy
            ,@Zaplacono
            ,@TerminZaplaty
            )

        SET @InvoiceCounter = @InvoiceCounter + 1;
        --END
        SET @NrFaktury = @NrFaktury + 1
    END

    FETCH NEXT
    FROM reader
    INTO @KlientId;
END

CLOSE reader

DEALLOCATE reader
GO

