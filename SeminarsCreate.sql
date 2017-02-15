USE [master]
GO
/****** Object:  Database [SeminarskaBaza]    Script Date: 15/2/2017 11:20:57 PM ******/
CREATE DATABASE [SeminarskaBaza]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SeminarskaBaza', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.ZIVOTINJA\MSSQL\DATA\SeminarskaBaza.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'SeminarskaBaza_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.ZIVOTINJA\MSSQL\DATA\SeminarskaBaza_log.ldf' , SIZE = 6912KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [SeminarskaBaza] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SeminarskaBaza].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SeminarskaBaza] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SeminarskaBaza] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SeminarskaBaza] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SeminarskaBaza] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SeminarskaBaza] SET ARITHABORT OFF 
GO
ALTER DATABASE [SeminarskaBaza] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [SeminarskaBaza] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [SeminarskaBaza] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SeminarskaBaza] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SeminarskaBaza] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SeminarskaBaza] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SeminarskaBaza] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SeminarskaBaza] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SeminarskaBaza] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SeminarskaBaza] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SeminarskaBaza] SET  DISABLE_BROKER 
GO
ALTER DATABASE [SeminarskaBaza] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SeminarskaBaza] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SeminarskaBaza] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SeminarskaBaza] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SeminarskaBaza] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SeminarskaBaza] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [SeminarskaBaza] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SeminarskaBaza] SET RECOVERY FULL 
GO
ALTER DATABASE [SeminarskaBaza] SET  MULTI_USER 
GO
ALTER DATABASE [SeminarskaBaza] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SeminarskaBaza] SET DB_CHAINING OFF 
GO
ALTER DATABASE [SeminarskaBaza] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [SeminarskaBaza] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'SeminarskaBaza', N'ON'
GO
USE [SeminarskaBaza]
GO
/****** Object:  StoredProcedure [dbo].[spPrijava]    Script Date: 15/2/2017 11:20:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPrijava]
@KorisnickoIme NVARCHAR(50),
@Lozinka NVARCHAR(50)
AS
BEGIN
	DECLARE @Count INT

	SELECT @Count = COUNT(KorisnickoIme) FROM Zaposlenik
	WHERE KorisnickoIme = @KorisnickoIme AND Lozinka = @Lozinka
	
	IF (@Count = 1)
	BEGIN
		Select 1 AS ReturnCode
	END
	ELSE
	BEGIN
		Select -1 AS ReturnCode
	END
END
GO
/****** Object:  Table [dbo].[Predbiljezba]    Script Date: 15/2/2017 11:20:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Predbiljezba](
	[IdPredbiljezba] [int] IDENTITY(1,1) NOT NULL,
	[IdSeminar] [int] NOT NULL,
	[Datum] [date] NOT NULL,
	[Ime] [nvarchar](50) NOT NULL,
	[Prezime] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](50) NULL,
	[Telefon] [nvarchar](20) NULL,
	[Status] [nvarchar](15) NULL,
 CONSTRAINT [PK__Predbilj__E55654B803317E3D] PRIMARY KEY CLUSTERED 
(
	[IdPredbiljezba] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Seminar]    Script Date: 15/2/2017 11:20:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Seminar](
	[IdSeminar] [int] IDENTITY(1,1) NOT NULL,
	[IdZaposlenik] [int] NOT NULL,
	[Naziv] [nvarchar](200) NOT NULL,
	[Opis] [nvarchar](500) NOT NULL,
	[Datum] [date] NOT NULL,
	[Popunjen] [bit] NULL CONSTRAINT [DF__Seminar__Popunje__2E1BDC42]  DEFAULT ((0)),
 CONSTRAINT [PK__Seminar__2E4E0B0307020F21] PRIMARY KEY CLUSTERED 
(
	[IdSeminar] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Zaposlenik]    Script Date: 15/2/2017 11:20:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Zaposlenik](
	[IdZaposlenik] [int] IDENTITY(1,1) NOT NULL,
	[Ime] [nvarchar](50) NOT NULL,
	[Prezime] [nvarchar](50) NOT NULL,
	[KorisnickoIme] [nvarchar](50) NOT NULL,
	[Lozinka] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK__Zaposlen__0E5CDA937F60ED59] PRIMARY KEY CLUSTERED 
(
	[IdZaposlenik] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Predbiljezba]  WITH CHECK ADD  CONSTRAINT [FK_Predbiljezba_Seminar] FOREIGN KEY([IdSeminar])
REFERENCES [dbo].[Seminar] ([IdSeminar])
GO
ALTER TABLE [dbo].[Predbiljezba] CHECK CONSTRAINT [FK_Predbiljezba_Seminar]
GO
ALTER TABLE [dbo].[Seminar]  WITH CHECK ADD  CONSTRAINT [FK_Seminar_Zaposlenik] FOREIGN KEY([IdZaposlenik])
REFERENCES [dbo].[Zaposlenik] ([IdZaposlenik])
GO
ALTER TABLE [dbo].[Seminar] CHECK CONSTRAINT [FK_Seminar_Zaposlenik]
GO
ALTER TABLE [dbo].[Predbiljezba]  WITH CHECK ADD  CONSTRAINT [CK__Predbilje__Statu__300424B4] CHECK  (([Status]='prihvacena' OR [Status]='odbijena'))
GO
ALTER TABLE [dbo].[Predbiljezba] CHECK CONSTRAINT [CK__Predbilje__Statu__300424B4]
GO
USE [master]
GO
ALTER DATABASE [SeminarskaBaza] SET  READ_WRITE 
GO
