USE [resourcesDW]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ventas]') AND type in (N'U'))
ALTER TABLE [dbo].[ventas] DROP CONSTRAINT IF EXISTS [FK__ventas__vehiculo__09A971A2]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ventas]') AND type in (N'U'))
ALTER TABLE [dbo].[ventas] DROP CONSTRAINT IF EXISTS [FK__ventas__clienteI__0D7A0286]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[vehiculos]') AND type in (N'U'))
ALTER TABLE [dbo].[vehiculos] DROP CONSTRAINT IF EXISTS [FK__vehiculos__tipoI__70DDC3D8]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[vehiculos]') AND type in (N'U'))
ALTER TABLE [dbo].[vehiculos] DROP CONSTRAINT IF EXISTS [FK__vehiculos__servi__72C60C4A]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[vehiculos]') AND type in (N'U'))
ALTER TABLE [dbo].[vehiculos] DROP CONSTRAINT IF EXISTS [FK__vehiculos__combu__71D1E811]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[provincias]') AND type in (N'U'))
ALTER TABLE [dbo].[provincias] DROP CONSTRAINT IF EXISTS [FK__provincia__paisI__01142BA1]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[clientes]') AND type in (N'U'))
ALTER TABLE [dbo].[clientes] DROP CONSTRAINT IF EXISTS [FK__clientes__lugarN__05D8E0BE]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ciudades]') AND type in (N'U'))
ALTER TABLE [dbo].[ciudades] DROP CONSTRAINT IF EXISTS [FK__ciudades__provin__02084FDA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ventas]') AND type in (N'U'))
ALTER TABLE [dbo].[ventas] DROP CONSTRAINT IF EXISTS [DF__ventas__id__656C112C]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[vehiculos]') AND type in (N'U'))
ALTER TABLE [dbo].[vehiculos] DROP CONSTRAINT IF EXISTS [DF__vehiculos__id__6383C8BA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[vehiculo_tipo]') AND type in (N'U'))
ALTER TABLE [dbo].[vehiculo_tipo] DROP CONSTRAINT IF EXISTS [DF__vehiculo_tip__id__6B24EA82]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[vehiculo_servicio]') AND type in (N'U'))
ALTER TABLE [dbo].[vehiculo_servicio] DROP CONSTRAINT IF EXISTS [DF__servicio_veh__id__693CA210]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[provincias]') AND type in (N'U'))
ALTER TABLE [dbo].[provincias] DROP CONSTRAINT IF EXISTS [DF__provincias__id__6754599E]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[paises]') AND type in (N'U'))
ALTER TABLE [dbo].[paises] DROP CONSTRAINT IF EXISTS [DF__paises__id__68487DD7]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[combustible]') AND type in (N'U'))
ALTER TABLE [dbo].[combustible] DROP CONSTRAINT IF EXISTS [DF__combustible__id__628FA481]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[clientes]') AND type in (N'U'))
ALTER TABLE [dbo].[clientes] DROP CONSTRAINT IF EXISTS [DF__clientes__id__6477ECF3]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ciudades]') AND type in (N'U'))
ALTER TABLE [dbo].[ciudades] DROP CONSTRAINT IF EXISTS [DF__ciudades__id__66603565]
GO
/****** Object:  Table [dbo].[ventas]    Script Date: 10/23/2021 9:14:24 PM ******/
DROP TABLE IF EXISTS [dbo].[ventas]
GO
/****** Object:  Table [dbo].[vehiculos]    Script Date: 10/23/2021 9:14:24 PM ******/
DROP TABLE IF EXISTS [dbo].[vehiculos]
GO
/****** Object:  Table [dbo].[vehiculo_tipo]    Script Date: 10/23/2021 9:14:24 PM ******/
DROP TABLE IF EXISTS [dbo].[vehiculo_tipo]
GO
/****** Object:  Table [dbo].[vehiculo_servicio]    Script Date: 10/23/2021 9:14:24 PM ******/
DROP TABLE IF EXISTS [dbo].[vehiculo_servicio]
GO
/****** Object:  Table [dbo].[provincias]    Script Date: 10/23/2021 9:14:24 PM ******/
DROP TABLE IF EXISTS [dbo].[provincias]
GO
/****** Object:  Table [dbo].[paises]    Script Date: 10/23/2021 9:14:24 PM ******/
DROP TABLE IF EXISTS [dbo].[paises]
GO
/****** Object:  Table [dbo].[combustible]    Script Date: 10/23/2021 9:14:24 PM ******/
DROP TABLE IF EXISTS [dbo].[combustible]
GO
/****** Object:  Table [dbo].[clientes]    Script Date: 10/23/2021 9:14:24 PM ******/
DROP TABLE IF EXISTS [dbo].[clientes]
GO
/****** Object:  Table [dbo].[ciudades]    Script Date: 10/23/2021 9:14:24 PM ******/
DROP TABLE IF EXISTS [dbo].[ciudades]
GO
USE [master]
GO
/****** Object:  Database [resourcesDW]    Script Date: 10/23/2021 9:14:24 PM ******/
DROP DATABASE IF EXISTS [resourcesDW]
GO
/****** Object:  Database [resourcesDW]    Script Date: 10/23/2021 9:14:24 PM ******/
CREATE DATABASE [resourcesDW]
 CONTAINMENT = NONE
 ON  PRIMARY
( NAME = N'resourcesDW', FILENAME = N'D:\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\resourcesDW.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON
( NAME = N'resourcesDW_log', FILENAME = N'D:\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\resourcesDW_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [resourcesDW].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [resourcesDW] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [resourcesDW] SET ANSI_NULLS OFF
GO
ALTER DATABASE [resourcesDW] SET ANSI_PADDING OFF
GO
ALTER DATABASE [resourcesDW] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [resourcesDW] SET ARITHABORT OFF
GO
ALTER DATABASE [resourcesDW] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [resourcesDW] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [resourcesDW] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [resourcesDW] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [resourcesDW] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [resourcesDW] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [resourcesDW] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [resourcesDW] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [resourcesDW] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [resourcesDW] SET  DISABLE_BROKER
GO
ALTER DATABASE [resourcesDW] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [resourcesDW] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [resourcesDW] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [resourcesDW] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [resourcesDW] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [resourcesDW] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [resourcesDW] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [resourcesDW] SET RECOVERY FULL
GO
ALTER DATABASE [resourcesDW] SET  MULTI_USER
GO
ALTER DATABASE [resourcesDW] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [resourcesDW] SET DB_CHAINING OFF
GO
ALTER DATABASE [resourcesDW] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF )
GO
ALTER DATABASE [resourcesDW] SET TARGET_RECOVERY_TIME = 60 SECONDS
GO
ALTER DATABASE [resourcesDW] SET DELAYED_DURABILITY = DISABLED
GO
EXEC sys.sp_db_vardecimal_storage_format N'resourcesDW', N'ON'
GO
ALTER DATABASE [resourcesDW] SET QUERY_STORE = OFF
GO
USE [resourcesDW]
GO
/****** Object:  Table [dbo].[ciudades]    Script Date: 10/23/2021 9:14:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ciudades](
	[id] [varchar](256) NOT NULL,
	[nombre] [varchar](100) NULL,
	[provinciaID] [varchar](256) NULL,
	[codigoEstatal] [varchar](100) NULL,
PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[clientes]    Script Date: 10/23/2021 9:14:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[clientes](
	[id] [varchar](256) NOT NULL,
	[nombres] [varchar](256) NULL,
	[apellidos] [varchar](256) NULL,
	[nacimiento] [date] NULL,
	[documento] [varchar](100) NULL,
	[lugarNacimiento] [varchar](256) NULL,
	[codigoPostal] [varchar](8) NULL,
	[telefono] [varchar](14) NULL,
PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[combustible]    Script Date: 10/23/2021 9:14:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[combustible](
	[id] [varchar](256) NOT NULL,
	[descripcion] [varchar](100) NULL,
	[codigo] [varchar](1) NULL,
PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[paises]    Script Date: 10/23/2021 9:14:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[paises](
	[id] [varchar](256) NOT NULL,
	[nombre] [varchar](256) NULL,
	[iso2] [varchar](2) NULL,
	[iso3] [varchar](3) NULL,
	[phoneCode] [smallint] NULL,
PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[provincias]    Script Date: 10/23/2021 9:14:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[provincias](
	[id] [varchar](256) NOT NULL,
	[nombre] [varchar](100) NULL,
	[paisID] [varchar](256) NULL,
PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vehiculo_servicio]    Script Date: 10/23/2021 9:14:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vehiculo_servicio](
	[id] [varchar](256) NOT NULL,
	[descripcion] [varchar](256) NULL,
	[codigo] [varchar](1) NULL,
PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vehiculo_tipo]    Script Date: 10/23/2021 9:14:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vehiculo_tipo](
	[id] [varchar](256) NOT NULL,
	[descripcion] [varchar](128) NULL,
	[codigo] [varchar](2) NULL,
PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vehiculos]    Script Date: 10/23/2021 9:14:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vehiculos](
	[id] [varchar](256) NOT NULL,
	[nombre] [varchar](100) NULL,
	[referencia] [varchar](100) NULL,
	[linea] [varchar](100) NULL,
	[color] [varchar](100) NULL,
	[tipoID] [varchar](256) NULL,
	[combustibleID] [varchar](256) NULL,
	[servicioID] [varchar](256) NULL,
PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ventas]    Script Date: 10/23/2021 9:14:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ventas](
	[id] [varchar](256) NOT NULL,
	[descripcion] [varchar](100) NULL,
	[clienteID] [varchar](256) NOT NULL,
	[vehiculoID] [varchar](256) NOT NULL,
	[EmpleadoID] [varchar](256) NULL,
	[fecha] [varchar](100) NULL,
	[sucursalID] [varchar](256) NULL,
	[cantidad] [int] NULL,
	[referencia] [varchar](100) NULL,
	[descuentos] [varchar](100) NULL,
	[totalFactura] [bigint] NULL
) ON [PRIMARY]
GO
INSERT [dbo].[ciudades] ([id], [nombre], [provinciaID], [codigoEstatal]) VALUES (N'27C89018-0534-480C-B719-5498EEE22D77', N'Chicago', N'66F6A606-F08A-4F84-AF71-4B1DA3571CC4', NULL)
GO
INSERT [dbo].[ciudades] ([id], [nombre], [provinciaID], [codigoEstatal]) VALUES (N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'Nueva York', N'E61F5493-E294-4753-82E1-8446F0B4410E', NULL)
GO
INSERT [dbo].[ciudades] ([id], [nombre], [provinciaID], [codigoEstatal]) VALUES (N'5526D776-861B-4085-9B5F-91D58221D161', N'California', NULL, NULL)
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'004e318c-5f47-4902-ae2c-79bd7fdbc603', N'Loredo', N'Gomez', CAST(N'2016-08-11' AS Date), N'3148695880', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'06340', N'37093300065')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0051c4de-4ecb-4621-910a-30d8e91eb3c6', N'Lucha', N'Duran', CAST(N'2006-02-15' AS Date), N'2754184555', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'54072', N'32598712954')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'00b40289-0b25-4c74-8732-270526c65c67', N'Graciela', N'Guerrero', CAST(N'2005-04-23' AS Date), N'5223097026', N'5526D776-861B-4085-9B5F-91D58221D161', N'76871', N'36653315811')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'00e2328f-27cd-4535-af7f-ca4eef6f810a', N'Alberto', N'Dominguez', CAST(N'2000-03-26' AS Date), N'8792789602', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'59772', N'38218144073')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'00eeb964-e528-4983-b117-86cb9fa86f07', N'Clàudia', N'Martin', CAST(N'2003-03-16' AS Date), N'8519813762', N'27C89018-0534-480C-B719-5498EEE22D77', N'21240', N'34289510846')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'00f93623-0237-4f2f-a10d-6286770df316', N'Miguel Angel', N'Garcia', CAST(N'2001-05-21' AS Date), N'3826568632', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'37357', N'39355500300')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'010c184d-3507-47b1-8100-7fd6c39f32e3', N'Raul', N'Marcos', CAST(N'2021-11-11' AS Date), N'2796918355', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'68654', N'39304681647')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'014f93a8-0960-455a-9d56-c29dc6e03372', N'Ángeles', N'Rey', CAST(N'2016-03-18' AS Date), N'1158157903', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'49054', N'37690607309')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0165a25a-d2f3-429e-a671-1c593ed1c36d', N'Angel', N'Pastor', CAST(N'2008-06-14' AS Date), N'8588416474', N'5526D776-861B-4085-9B5F-91D58221D161', N'63241', N'36120818473')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'016ebcbb-ff4a-4df5-9248-40baa026d915', N'First names', N'Leon', CAST(N'2016-11-27' AS Date), N'6876619945', N'27C89018-0534-480C-B719-5498EEE22D77', N'04143', N'39477156797')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'01760f82-ada1-4baa-8d1b-710ab78dd46c', N'Nicolás', N'Garrido', CAST(N'2003-02-11' AS Date), N'7391189879', N'27C89018-0534-480C-B719-5498EEE22D77', N'82476', N'34204956237')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'01aec6b9-03c3-420e-a747-96b61153a59c', N'Angélica', N'Medina', CAST(N'2016-12-28' AS Date), N'4873055612', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'02595', N'30077029613')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'01b75ae0-7d9e-40b7-8962-d24d8e966680', N'Cobura', N'Gutierrez', CAST(N'2001-01-07' AS Date), N'4213978477', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'21773', N'32760154833')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'01b904e8-b8e5-460e-bb04-7aa8de8cdcde', N'Raimunda', N'Alonso', CAST(N'2015-07-12' AS Date), N'0904682450', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'04744', N'39021050812')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'01ca4abb-2e42-417c-9a51-16c2a1c7476f', N'Ester', N'Munoz', CAST(N'2020-10-05' AS Date), N'3647377052', N'5526D776-861B-4085-9B5F-91D58221D161', N'62900', N'38182033402')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'01e85dcc-a603-4f99-8ec2-52b130bdb20c', N'Jacinta', N'Crespo', CAST(N'2004-02-15' AS Date), N'8169843735', N'27C89018-0534-480C-B719-5498EEE22D77', N'60605', N'39016492062')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0225d977-f255-4a7b-bce9-aa28409168d2', N'Ainhoa', N'Diaz', CAST(N'2014-02-24' AS Date), N'8847694387', N'5526D776-861B-4085-9B5F-91D58221D161', N'88484', N'32611433448')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0267f702-c716-44e0-8dc8-13f3ac08b765', N'Aimon', N'Herrero', CAST(N'2014-03-17' AS Date), N'3142035708', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'15128', N'36068423210')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'02f4ed3f-c40c-4da8-9ac4-f0eb0c454de1', N'Ainhoa', N'Vicente', CAST(N'2013-04-30' AS Date), N'5482657645', N'27C89018-0534-480C-B719-5498EEE22D77', N'51303', N'32637976940')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'02ff51e8-ed02-4b24-a288-deb31df228a6', N'Emmanuel', N'Cano', CAST(N'2018-12-10' AS Date), N'9032601996', N'5526D776-861B-4085-9B5F-91D58221D161', N'69186', N'39149325743')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0321d851-7d91-4b9c-9397-f18150191969', N'Guillermo', N'Garrido', CAST(N'2000-10-18' AS Date), N'9423045866', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'97576', N'30104807683')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0333b015-3daf-4f35-ade2-b60880cc9a58', N'Josep', N'Ortega', CAST(N'2004-07-30' AS Date), N'2017630865', N'5526D776-861B-4085-9B5F-91D58221D161', N'44349', N'37570121262')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'033a9a27-545c-4d2a-a5ea-d3280319746b', N'Modesta', N'Caballero', CAST(N'2019-02-23' AS Date), N'4402775716', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'57843', N'37492138531')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'035c06a0-faac-4923-a2c7-efebe029361a', N'Ismael', N'Leon', CAST(N'2010-06-16' AS Date), N'4679684107', N'5526D776-861B-4085-9B5F-91D58221D161', N'64578', N'34907582063')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'03733241-78e4-4467-a0a4-2d90956bd0e1', N'Margarita', N'Vazquez', CAST(N'2000-12-09' AS Date), N'1573780272', N'27C89018-0534-480C-B719-5498EEE22D77', N'57190', N'35253573201')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'03a84c78-7792-487a-9308-a81a153b0bbb', N'Purificación', N'Castro', CAST(N'2006-04-14' AS Date), N'0058257267', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'54174', N'33815895818')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'03be99ed-8df6-4c4a-b88b-823e9cdf8bfa', N'Ignado', N'Menendez', CAST(N'2007-09-20' AS Date), N'3780986745', N'5526D776-861B-4085-9B5F-91D58221D161', N'16242', N'38745059839')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0412d3f4-000c-446f-ad5c-210b5027267c', N'Samuel', N'Navarro', CAST(N'2010-09-10' AS Date), N'1523768564', N'27C89018-0534-480C-B719-5498EEE22D77', N'69711', N'36172315933')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0422bfa5-3443-4071-830d-e02ce8f333d8', N'Victoria', N'Vazquez', CAST(N'2018-09-06' AS Date), N'7701701860', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'32252', N'33255572392')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'046c43d8-a677-41d9-be05-860a103c4bf0', N'Adrián', N'Redondo', CAST(N'2000-04-25' AS Date), N'1313704163', N'5526D776-861B-4085-9B5F-91D58221D161', N'90992', N'38991035586')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'054e418a-b3b7-41b5-aa6b-33f175c6cec8', N'Luisa', N'Moya', CAST(N'2008-11-28' AS Date), N'7460775930', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'56955', N'39145134499')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'056bc5d2-cec8-4d19-826e-294a71724563', N'Elisa', N'Mendez', CAST(N'2011-11-05' AS Date), N'5312535110', N'5526D776-861B-4085-9B5F-91D58221D161', N'47893', N'35879796223')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'057e53df-e218-4713-a92a-b6237c41c3c8', N'Thiare', N'Guerrero', CAST(N'2019-01-28' AS Date), N'1413275484', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'74544', N'38243472257')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0580f163-ef5f-4d7c-a2ee-97794d7660e7', N'Hugo', N'Vidal', CAST(N'2019-12-03' AS Date), N'3017959980', N'5526D776-861B-4085-9B5F-91D58221D161', N'58992', N'33221220569')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'058c9e78-2126-4323-a123-e31d66514612', N'Haydée', N'Guerrero', CAST(N'2014-06-01' AS Date), N'6943190676', N'27C89018-0534-480C-B719-5498EEE22D77', N'10774', N'37812771174')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'05c9a57b-4035-4e5d-ac8e-4042570f1588', N'Keiko', N'Ramirez', CAST(N'2017-04-07' AS Date), N'8458235556', N'5526D776-861B-4085-9B5F-91D58221D161', N'46804', N'33556796481')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'06332f1f-c832-47d8-9c82-6e9f766b4485', N'Alma', N'Rey', CAST(N'2004-06-23' AS Date), N'4778861220', N'27C89018-0534-480C-B719-5498EEE22D77', N'98615', N'36374126680')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'06366376-8ccb-4168-bc52-f722806231e4', N'Vanesa', N'Ortiz', CAST(N'2006-07-28' AS Date), N'5254390538', N'5526D776-861B-4085-9B5F-91D58221D161', N'24370', N'33107932274')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'064a2132-cdbf-42a0-909c-b718d0697ae5', N'Fernanda', N'Nieto', CAST(N'2000-04-26' AS Date), N'7362063057', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'38468', N'35367324895')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'064af758-3656-4e04-98ec-b8777cc21de4', N'Thiago', N'Gonzalez', CAST(N'2007-07-25' AS Date), N'3888648805', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'89697', N'34386873022')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0686866e-dba0-4c2e-95c0-d0ea433d0de6', N'Sergi', N'Izquierdo', CAST(N'2019-10-13' AS Date), N'4276733353', N'27C89018-0534-480C-B719-5498EEE22D77', N'48738', N'32466148421')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0699efc2-feb7-4f19-93ee-96687cc10a3d', N'Bautista', N'Marin', CAST(N'2012-06-03' AS Date), N'3639375396', N'27C89018-0534-480C-B719-5498EEE22D77', N'79457', N'39896825378')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'06b100e0-cbc8-41f3-b361-3ce27c235de0', N'Marc', N'Mora', CAST(N'2014-07-03' AS Date), N'2705982100', N'27C89018-0534-480C-B719-5498EEE22D77', N'12546', N'37625147108')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'06e16a4a-799d-45bd-9004-deda746fb37a', N'Borja', N'Vicente', CAST(N'2021-04-03' AS Date), N'4582033056', N'27C89018-0534-480C-B719-5498EEE22D77', N'26834', N'36964888971')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'06ea213b-0cbd-4397-8f31-72cae84b409b', N'Gloria', N'Bravo', CAST(N'2005-05-24' AS Date), N'0361319672', N'27C89018-0534-480C-B719-5498EEE22D77', N'38209', N'32715327491')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'06f296c5-7d28-4535-bb47-0c89e815238c', N'Tomás', N'Diaz', CAST(N'2019-01-06' AS Date), N'9726186723', N'27C89018-0534-480C-B719-5498EEE22D77', N'09199', N'31641154090')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'071024e0-43b0-477f-bfa6-0210a0743559', N'Joan', N'Alvarez', CAST(N'2008-07-03' AS Date), N'0588423788', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'90052', N'37039692039')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'071068cb-b27a-46a9-b318-2c1583c9cab4', N'Emiliano', N'Carrasco', CAST(N'2004-05-12' AS Date), N'2369137632', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'08951', N'37764580014')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'072327f5-30f9-44a2-bfc5-d2e77f0374af', N'Lucas', N'Herrera', CAST(N'2008-12-01' AS Date), N'5980309201', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'62051', N'38088927478')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'07398d39-2892-4075-bb02-8815f21767f4', N'Mireia', N'Caballero', CAST(N'2021-12-31' AS Date), N'8231832246', N'5526D776-861B-4085-9B5F-91D58221D161', N'11959', N'33965989756')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'07a90832-8e1d-4b6e-a07e-1b8919dbd450', N'Ximena', N'Herrero', CAST(N'2009-10-10' AS Date), N'2946016979', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'90205', N'37490056145')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'07d4f2c2-75ac-42f3-9dad-78db9fa13517', N'Fanuco', N'Suarez', CAST(N'2007-08-08' AS Date), N'2047524466', N'5526D776-861B-4085-9B5F-91D58221D161', N'12241', N'30582729132')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'081f467f-0b1e-4ace-aafe-b8f8b9c593fb', N'Catalina', N'Romero', CAST(N'2019-07-12' AS Date), N'1180966699', N'5526D776-861B-4085-9B5F-91D58221D161', N'31428', N'31597771984')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0864500e-4a4e-4ddf-aed7-83c472be7861', N'Paco', N'Cruz', CAST(N'2007-02-09' AS Date), N'4155541980', N'5526D776-861B-4085-9B5F-91D58221D161', N'25271', N'38613631990')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0867af02-0143-45d7-99af-302c9345a99e', N'Aimon', N'Ferrer', CAST(N'2001-06-02' AS Date), N'9943426225', N'27C89018-0534-480C-B719-5498EEE22D77', N'92291', N'32507433631')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'088b6ff9-9c5f-449b-9f14-bf54bd0f1f3e', N'Ane', N'Vazquez', CAST(N'2016-03-14' AS Date), N'0349681908', N'27C89018-0534-480C-B719-5498EEE22D77', N'20532', N'38144148957')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'08f92c89-6066-43cc-81bd-896f086c024a', N'Dylan', N'Cano', CAST(N'2017-08-11' AS Date), N'5649586443', N'5526D776-861B-4085-9B5F-91D58221D161', N'84891', N'36444751657')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'090b8d50-9ad7-4d0f-9076-4e910ab20cba', N'Carolina', N'Lopez', CAST(N'2020-08-24' AS Date), N'0784288948', N'5526D776-861B-4085-9B5F-91D58221D161', N'49232', N'31433432722')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'09116752-3e52-48e1-9caf-cfe31a1d079e', N'Álvaro', N'Vazquez', CAST(N'2003-02-19' AS Date), N'3892554053', N'5526D776-861B-4085-9B5F-91D58221D161', N'82870', N'37173509576')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'095cda7d-b577-4365-ae5d-ff1c038b8e83', N'Estefanía', N'Sanz', CAST(N'2006-08-14' AS Date), N'3859291831', N'27C89018-0534-480C-B719-5498EEE22D77', N'13761', N'35964357419')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'095d4917-84b2-4576-94bd-2216bf2a25fb', N'Lidia', N'Martin', CAST(N'2018-09-07' AS Date), N'7715283417', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'14994', N'33622613796')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'096bb41a-e69e-4a5e-9129-a6294851ab34', N'Flora', N'Dominguez', CAST(N'2013-01-07' AS Date), N'5488166701', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'05113', N'35486236717')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'09847896-2cd4-47d4-845b-14f51c460c75', N'Marcelo', N'Herrero', CAST(N'2010-02-13' AS Date), N'6421797529', N'27C89018-0534-480C-B719-5498EEE22D77', N'75034', N'39587504948')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0985500b-8c25-4fea-aa15-ee233e347a43', N'Caro', N'Menendez', CAST(N'2000-06-02' AS Date), N'8516643400', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'85934', N'30844981162')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'098d38e2-a6e3-42b6-b422-8784ef1fbe4c', N'Josep', N'Munoz', CAST(N'2015-04-21' AS Date), N'9177331360', N'27C89018-0534-480C-B719-5498EEE22D77', N'62631', N'35733292667')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'09a65280-3dca-47c0-9d6c-595a73542979', N'Emmanuel', N'Saez', CAST(N'2007-05-13' AS Date), N'1473296082', N'5526D776-861B-4085-9B5F-91D58221D161', N'58360', N'33468786155')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'09ad1471-8601-4332-859e-5f5dfd06b0c9', N'Miguela', N'Cortes', CAST(N'2009-08-28' AS Date), N'0234417782', N'5526D776-861B-4085-9B5F-91D58221D161', N'62872', N'33099970033')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'09b9d497-a3e3-4db0-9cc6-fa7abb3385fd', N'Narcisa', N'Gonzalez', CAST(N'2016-02-03' AS Date), N'0080056402', N'27C89018-0534-480C-B719-5498EEE22D77', N'33321', N'30388427180')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0a265cd0-a43e-44bf-9c89-86cd0119d800', N'Lea', N'Leon', CAST(N'2009-03-22' AS Date), N'6142256813', N'5526D776-861B-4085-9B5F-91D58221D161', N'65713', N'30475269517')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0a4ad3ee-2a3a-4e83-a40e-91f95bc5805a', N'Bea', N'Marin', CAST(N'2012-03-05' AS Date), N'5949773842', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'41242', N'36346053840')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0a9f9146-2c8e-4b2c-8556-b582ccdae561', N'Ángel', N'Morales', CAST(N'2000-08-24' AS Date), N'7049751654', N'5526D776-861B-4085-9B5F-91D58221D161', N'32908', N'36888025245')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0ab2e5c8-ac87-496b-9616-9c86cc06fb02', N'Gig', N'Castro', CAST(N'2016-01-25' AS Date), N'3117618799', N'27C89018-0534-480C-B719-5498EEE22D77', N'15365', N'39948060749')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0b154bbd-b8c1-42ab-b25f-cdd6814e4139', N'Xavier', N'Gonzalez', CAST(N'2012-01-25' AS Date), N'2850319883', N'5526D776-861B-4085-9B5F-91D58221D161', N'66724', N'35761660795')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0b230b18-913f-4519-9e8b-123cc240f5a0', N'Eduardo', N'Duran', CAST(N'2000-11-25' AS Date), N'9324106182', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'22784', N'38731124968')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0b2ff44d-c09d-4649-be5d-7c740ebb2adf', N'Cortez', N'Pastor', CAST(N'2002-02-12' AS Date), N'5380145289', N'27C89018-0534-480C-B719-5498EEE22D77', N'01590', N'39456642301')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0b50bc4c-f7bd-4374-9044-5468108a5e51', N'Pedro', N'Soto', CAST(N'2011-07-11' AS Date), N'7854741222', N'5526D776-861B-4085-9B5F-91D58221D161', N'11837', N'36688959662')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0b52f9d9-799b-413a-90c0-f8a28c897ad5', N'Karina', N'Arias', CAST(N'2010-12-05' AS Date), N'2850942531', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'26804', N'35916962807')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0b5c246a-fb20-426f-ac6d-92f90edbaf04', N'Hortensia', N'Prieto', CAST(N'2001-02-05' AS Date), N'7618169696', N'27C89018-0534-480C-B719-5498EEE22D77', N'35695', N'30403646915')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0b5f8005-09b0-4a55-b45c-59e938cae6e5', N'Ilda', N'Vazquez', CAST(N'2008-11-10' AS Date), N'8999980123', N'27C89018-0534-480C-B719-5498EEE22D77', N'20672', N'35659798693')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0b760825-516b-4d52-bfb8-0f3ae6fbd331', N'Montana', N'Herrero', CAST(N'2007-03-27' AS Date), N'5273826180', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'50353', N'30295458531')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0b94ec06-34b0-4bcb-93bc-031993454b3b', N'Joaquina', N'Crespo', CAST(N'2003-06-30' AS Date), N'3189908982', N'5526D776-861B-4085-9B5F-91D58221D161', N'53677', N'39683619474')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0ba5b897-c246-480d-9b78-9ef116f26770', N'Camilo', N'Ortiz', CAST(N'2015-04-28' AS Date), N'5715180593', N'27C89018-0534-480C-B719-5498EEE22D77', N'37619', N'36328849067')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0bb319da-f735-43f4-a519-d4776ce565ee', N'Serafina', N'Caballero', CAST(N'2005-04-08' AS Date), N'9554558942', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'77237', N'32234429739')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0bb72445-4f55-4767-a706-a8085d3c6325', N'Florencia', N'Jimenez', CAST(N'2015-12-15' AS Date), N'2456627286', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'35354', N'37575041897')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0be24d6e-9f40-4cf5-9139-b42ea1add864', N'Leticia', N'Castillo', CAST(N'2010-08-01' AS Date), N'2072577151', N'27C89018-0534-480C-B719-5498EEE22D77', N'60933', N'35861141065')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0bec7cbd-c4b1-4b76-bb9e-dde629488fb3', N'Adrián', N'Martin', CAST(N'2014-09-06' AS Date), N'2294186921', N'5526D776-861B-4085-9B5F-91D58221D161', N'00811', N'37266464873')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0c2d6e3b-ee40-41f2-a22b-45b49394c008', N'Vanessa', N'Sanchez', CAST(N'2013-04-28' AS Date), N'7744904371', N'27C89018-0534-480C-B719-5498EEE22D77', N'45444', N'38342536607')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0c5253c5-b3aa-4ed3-bbf8-acb2d98e2cb2', N'Aurelia', N'Andres', CAST(N'2017-02-12' AS Date), N'3810885098', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'01502', N'39834352136')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0c55a90e-ba49-4281-bf66-d38f6bebbc18', N'Emilio', N'Diaz', CAST(N'2014-12-13' AS Date), N'7552225549', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'58513', N'31868203090')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0c7f3da9-86bf-4378-980b-5456f97fe4f1', N'Micaela', N'Lorenzo', CAST(N'2006-09-03' AS Date), N'0366310506', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'83425', N'33312336888')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0c8c438b-cdcb-4c1e-80ec-42f44654a984', N'Noelia', N'Fernandez', CAST(N'2009-03-16' AS Date), N'9377695440', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'73202', N'30050122199')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0cc3c85a-c5e2-4fad-aa21-53ea0957e65f', N'Jacqueline', N'Martinez', CAST(N'2011-09-25' AS Date), N'3034589098', N'27C89018-0534-480C-B719-5498EEE22D77', N'24390', N'38281735436')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0ccf2f8c-8e65-4d32-877b-f8715db1e53a', N'Miguel', N'Arias', CAST(N'2004-05-25' AS Date), N'7472903524', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'38804', N'30832613889')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0d69d3c4-2aff-4f1b-820b-60caec9fd738', N'Haydée', N'Ramos', CAST(N'2009-02-09' AS Date), N'9847682014', N'5526D776-861B-4085-9B5F-91D58221D161', N'06345', N'38172285203')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0d97ac54-7072-4936-908b-35c2c3099726', N'adrian', N'Torres', CAST(N'2006-03-25' AS Date), N'7438403767', N'27C89018-0534-480C-B719-5498EEE22D77', N'30964', N'31648587505')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0df8ac8c-67d8-469a-acb3-fca40746ddcf', N'Fatima', N'Castro', CAST(N'2020-04-02' AS Date), N'7443045227', N'27C89018-0534-480C-B719-5498EEE22D77', N'23894', N'36494466680')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0dfcabb8-c900-4c5b-908a-54627497d224', N'Juan Ignacio', N'Delgado', CAST(N'2020-04-27' AS Date), N'0595447681', N'27C89018-0534-480C-B719-5498EEE22D77', N'64818', N'39403369035')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0e23bbb7-3c15-40c6-8858-823a08b6f835', N'Silvia', N'Carrasco', CAST(N'2019-02-28' AS Date), N'8209562444', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'31527', N'39339130700')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0e4b418e-7c22-48f2-8a09-74820a96758f', N'Emmanuel', N'Dominguez', CAST(N'2019-01-04' AS Date), N'9803657911', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'03919', N'36793329186')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0edd01fe-2970-40eb-9619-1d4fd6b137ba', N'Tomás', N'Prieto', CAST(N'2001-12-12' AS Date), N'8533017972', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'81070', N'39344252701')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0ee5454c-71e2-4d47-a222-e3de8ed12eee', N'Nicolás', N'Molina', CAST(N'2003-07-26' AS Date), N'6350349927', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'39191', N'38606549711')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0efd49e2-1aa1-478c-a52d-e4779af3b38b', N'Matilde', N'Dominguez', CAST(N'2017-09-27' AS Date), N'4248019305', N'27C89018-0534-480C-B719-5498EEE22D77', N'97358', N'34494715746')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0f1d6dc2-7a87-468c-a02c-c8c8fb1f248c', N'Blanca', N'Alvarez', CAST(N'2006-11-24' AS Date), N'1581697134', N'5526D776-861B-4085-9B5F-91D58221D161', N'60916', N'30143734162')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0f27bf0f-42b4-4fde-a281-31b8908144ba', N'Kevin', N'Medina', CAST(N'2002-03-14' AS Date), N'1750304876', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'68976', N'36435401604')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0f39dab7-3c92-42ff-8eed-4b2db79d56bb', N'Cruz', N'Vicente', CAST(N'2017-12-11' AS Date), N'1549642065', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'88018', N'31331726885')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0f4b9630-7eda-408e-aba1-5f4fdf776b7c', N'Rosario', N'Calvo', CAST(N'2018-03-14' AS Date), N'4535624702', N'27C89018-0534-480C-B719-5498EEE22D77', N'82813', N'36631253081')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0fac5e56-1759-448a-af84-c3676dff13af', N'Larenzo', N'Nunez', CAST(N'2005-09-24' AS Date), N'4152853433', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'02840', N'33215037452')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0fbe400b-0c36-4be1-a081-0e6fc86319d7', N'Eufemia', N'Vila', CAST(N'2007-09-15' AS Date), N'7482828264', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'77602', N'31644883768')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'0fd3970f-6edf-4526-8962-d745b8c310b4', N'Froilana', N'Ortiz', CAST(N'2013-01-06' AS Date), N'6742993581', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'55872', N'36749034490')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'10335e8a-5b2e-49ff-9e35-86b5cc3ee7ea', N'Ricardo', N'Sanz', CAST(N'2020-08-22' AS Date), N'0537368783', N'5526D776-861B-4085-9B5F-91D58221D161', N'61826', N'38415771495')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'104a288a-770c-4468-9aab-9eff099da24c', N'Enka', N'Herrera', CAST(N'2010-08-28' AS Date), N'4735099685', N'27C89018-0534-480C-B719-5498EEE22D77', N'43014', N'38671480035')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'104c9ae3-d8e5-45ab-84fb-7b9335be76c5', N'Fulberta', N'Mendez', CAST(N'2015-09-10' AS Date), N'9311263179', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'51663', N'34417596598')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'10ae4436-c542-42b3-a158-6e31274d8356', N'Marcelina', N'Ruiz', CAST(N'2000-02-09' AS Date), N'2909649759', N'5526D776-861B-4085-9B5F-91D58221D161', N'59689', N'31272757243')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'10c61d40-2a8d-47e1-b04d-c4c883c1ecda', N'Berta', N'Pardo', CAST(N'2012-04-28' AS Date), N'2268455252', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'32881', N'30382274063')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'10de40b2-4857-486a-94f9-82459920e853', N'Ramira', N'Torres', CAST(N'2004-11-05' AS Date), N'9176645404', N'5526D776-861B-4085-9B5F-91D58221D161', N'40898', N'37069745947')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'10ee2d24-1233-430d-84ef-77290c54956e', N'Encarnación', N'Saez', CAST(N'2006-04-17' AS Date), N'1276370172', N'5526D776-861B-4085-9B5F-91D58221D161', N'79579', N'36744227716')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'10f83a03-133e-447e-a2cb-192f93a80bf6', N'Ramona', N'Herrera', CAST(N'2011-11-05' AS Date), N'5456698404', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'17452', N'31381956136')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'10fb1835-74fe-43cf-8f09-8616653efcd9', N'Camilo', N'Cano', CAST(N'2003-12-05' AS Date), N'7520168396', N'27C89018-0534-480C-B719-5498EEE22D77', N'31904', N'31124718015')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1102e91d-2752-479a-a22e-dfd6780f5016', N'Ester', N'Rubio', CAST(N'2017-01-29' AS Date), N'6338344942', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'62230', N'34912308390')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'11201767-0f87-4349-a0f4-0a09125aa587', N'Emmanuel', N'Herrero', CAST(N'2014-07-16' AS Date), N'0873592315', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'76328', N'32494911517')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'112b1a35-dd0f-4d8d-bead-3c02300392a3', N'Jose manuel', N'Mendez', CAST(N'2011-08-01' AS Date), N'6812010696', N'5526D776-861B-4085-9B5F-91D58221D161', N'91485', N'37157080701')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'113d1d1b-56c0-4a85-9092-11260a1895e1', N'Adisoda', N'Suarez', CAST(N'2002-08-23' AS Date), N'6092905741', N'27C89018-0534-480C-B719-5498EEE22D77', N'68437', N'35953647975')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'118dc73c-3bfa-461a-84ce-3ac33b0a1a1f', N'Bronco', N'Reyes', CAST(N'2018-11-19' AS Date), N'4331570110', N'27C89018-0534-480C-B719-5498EEE22D77', N'08385', N'39964090098')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'119cf0a6-a9b9-426b-a6b2-39382b1433f4', N'Caridad', N'Pardo', CAST(N'2019-01-24' AS Date), N'7733499809', N'27C89018-0534-480C-B719-5498EEE22D77', N'46733', N'33771864843')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'11b29fad-5b3d-494b-82c4-4c2c9c9fdf51', N'Montego', N'Rubio', CAST(N'2016-11-12' AS Date), N'1750375697', N'27C89018-0534-480C-B719-5498EEE22D77', N'23413', N'34554945605')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'11bdd1fd-b84e-40d4-b024-2472ba69ee54', N'Miguel Angel', N'Diaz', CAST(N'2010-12-23' AS Date), N'9896450881', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'81675', N'31717119892')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'11d94d8d-66af-498a-91bb-de6155830ae3', N'Flavia', N'Vega', CAST(N'2003-09-03' AS Date), N'1207471170', N'5526D776-861B-4085-9B5F-91D58221D161', N'18872', N'30279350077')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'11fd704e-7ce9-4d64-be3c-9973c62f014e', N'Consuelo', N'Guerrero', CAST(N'2014-02-11' AS Date), N'0508840865', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'93992', N'35991041826')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'120d000f-023e-4549-80fb-f8a7bcf3bfc5', N'martin', N'Aguilar', CAST(N'2011-09-16' AS Date), N'2977897030', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'39239', N'39762428314')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1211a90a-f72d-4c3e-8078-6cf51ac883d3', N'Gael', N'Delgado', CAST(N'2007-09-12' AS Date), N'5754306985', N'5526D776-861B-4085-9B5F-91D58221D161', N'21506', N'33775279334')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'123a08f6-586d-4ab7-a28c-630e9e2aac82', N'Santino', N'Molina', CAST(N'2000-05-19' AS Date), N'8537632468', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'81096', N'39358629640')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'125cf4d2-d7ae-4602-92e7-cf38baa91aab', N'Emilio', N'Nieto', CAST(N'2014-06-25' AS Date), N'5314576779', N'5526D776-861B-4085-9B5F-91D58221D161', N'06821', N'30780303678')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'128405b7-b4ad-4db3-a58b-0f12af166810', N'Clotilde', N'Rodriguez', CAST(N'2020-08-06' AS Date), N'5519864634', N'5526D776-861B-4085-9B5F-91D58221D161', N'70213', N'35386166056')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'12c70f5b-d64a-43ba-a7f8-eaa609cdf93b', N'Adelaida', N'Velasco', CAST(N'2019-01-15' AS Date), N'2110328127', N'27C89018-0534-480C-B719-5498EEE22D77', N'74701', N'34242421273')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'12ef4dd7-3099-45ff-8e2c-91b12ca8f308', N'Ulrica', N'Martin', CAST(N'2013-09-17' AS Date), N'3158215090', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'82919', N'39796029189')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'131525f7-9630-4087-97af-264e390ebe13', N'Ramona', N'Vila', CAST(N'2006-09-14' AS Date), N'6643623058', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'94785', N'37955592807')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1315a1c6-c945-459b-acf8-9504d5d69a46', N'Micaela', N'Fuentes', CAST(N'2020-01-23' AS Date), N'9850151307', N'5526D776-861B-4085-9B5F-91D58221D161', N'30804', N'33041087600')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'131c2761-6d43-4653-88b1-c7c6f41307cb', N'Fátima', N'Romero', CAST(N'2015-09-24' AS Date), N'0410277365', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'35125', N'36489394957')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1337548e-fe4a-466f-97a4-90bf2dd5c915', N'Federico', N'Velasco', CAST(N'2006-08-21' AS Date), N'6921731689', N'5526D776-861B-4085-9B5F-91D58221D161', N'10172', N'32634028808')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'134df16d-1fff-4f59-b033-2a9226eb4e3d', N'Serafina', N'Leon', CAST(N'2018-08-24' AS Date), N'5777724033', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'59509', N'37966479238')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'135f7eab-7709-4bff-9b31-5ffe668ed697', N'Daniel', N'Name', CAST(N'2019-05-26' AS Date), N'1288335760', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'98922', N'30701685131')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'137f5d06-51c0-454d-a518-1747dc293b34', N'Josué', N'Martin', CAST(N'2016-05-06' AS Date), N'7148338399', N'5526D776-861B-4085-9B5F-91D58221D161', N'53791', N'39210194190')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'13926134-25d9-47e8-8ceb-479beea8da9e', N'Mònica', N'Gutierrez', CAST(N'2020-07-08' AS Date), N'1759403287', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'46370', N'32769410566')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'13fa5309-bc72-4ff6-8aa8-8f9d67d1a656', N'Emmanuel', N'Flores', CAST(N'2013-07-22' AS Date), N'4156465019', N'27C89018-0534-480C-B719-5498EEE22D77', N'19936', N'39170363027')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'140dea08-880d-4019-a272-95bc63e7eede', N'Nieves', N'Romero', CAST(N'2016-08-02' AS Date), N'8538663391', N'5526D776-861B-4085-9B5F-91D58221D161', N'98109', N'39920244262')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'140e234d-50f6-4ac1-8da2-63b4e846d3e3', N'Enriqueta', N'Nunez', CAST(N'2007-06-03' AS Date), N'3075636321', N'27C89018-0534-480C-B719-5498EEE22D77', N'63626', N'37360157681')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1435d749-b485-4a5f-9ceb-2871a741c5a2', N'Lorena', N'Navarro', CAST(N'2008-02-16' AS Date), N'0673949515', N'27C89018-0534-480C-B719-5498EEE22D77', N'50274', N'37320090322')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'147c3b43-bdae-48c6-9819-30230e6cce4a', N'Rodrigo', N'Torres', CAST(N'2019-01-02' AS Date), N'4282974764', N'5526D776-861B-4085-9B5F-91D58221D161', N'58633', N'30702508462')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1490465e-b0c5-421f-b125-34c3a110807d', N'Gretel', N'Garcia', CAST(N'2020-01-12' AS Date), N'9253758581', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'07020', N'37880731798')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'14afa31c-4b67-4950-a3a6-0f7e759e01c8', N'Mayte', N'Aguilar', CAST(N'2021-02-14' AS Date), N'1875748665', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'12235', N'38228457799')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'14e3113e-2e28-4d63-aec6-aa6b493e8e85', N'Raquel', N'Carrasco', CAST(N'2014-05-07' AS Date), N'6011138307', N'27C89018-0534-480C-B719-5498EEE22D77', N'11588', N'35320973531')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'14ecb275-7b4d-4e70-88cf-29c0b926a689', N'Jaime', N'Lorenzo', CAST(N'2017-05-06' AS Date), N'0744644990', N'27C89018-0534-480C-B719-5498EEE22D77', N'47677', N'31182077382')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1509ffec-45be-43a8-a0b7-1de5dacd1969', N'Mery', N'Navarro', CAST(N'2019-09-09' AS Date), N'6780962338', N'27C89018-0534-480C-B719-5498EEE22D77', N'63531', N'33077021985')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1511104d-0094-483c-b418-f71336993656', N'Ana María', N'Calvo', CAST(N'2021-09-16' AS Date), N'5883581487', N'5526D776-861B-4085-9B5F-91D58221D161', N'23023', N'39691960696')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'15381e88-24a6-4ebd-b817-f64138050527', N'Caro', N'Calvo', CAST(N'2012-10-25' AS Date), N'2092589306', N'27C89018-0534-480C-B719-5498EEE22D77', N'15229', N'39394653371')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'158047ce-7e97-4e6c-85a2-ee8532d606c6', N'Sergio', N'Medina', CAST(N'2006-10-23' AS Date), N'5460425219', N'5526D776-861B-4085-9B5F-91D58221D161', N'19745', N'31923752391')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1580684a-62d9-4df1-9166-ecef33d6ec9c', N'Aurelia', N'Jimenez', CAST(N'2010-07-28' AS Date), N'7051738716', N'27C89018-0534-480C-B719-5498EEE22D77', N'76079', N'31735284973')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'15912348-c1f7-4e16-af4b-8e4115e8416b', N'Samuel', N'Alonso', CAST(N'2019-08-14' AS Date), N'9638100440', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'71906', N'32953049096')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'15dd37fb-947b-4ee7-820d-a61eb5c95285', N'Estefanía', N'Molina', CAST(N'2011-12-30' AS Date), N'8539374570', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'88240', N'37838376986')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1642acdc-a249-4614-8197-a48c64f3ef8d', N'Alodia', N'Munoz', CAST(N'2020-05-20' AS Date), N'8263402959', N'5526D776-861B-4085-9B5F-91D58221D161', N'56669', N'37772115538')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'16436eec-0c89-49c7-b9aa-b29a71b87898', N'Manuel', N'Diaz', CAST(N'2017-09-06' AS Date), N'9286149611', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'69670', N'31815458664')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'164fa502-43f3-4100-8541-1ae7323a1371', N'Thiare', N'Lorenzo', CAST(N'2008-02-07' AS Date), N'4364591724', N'27C89018-0534-480C-B719-5498EEE22D77', N'82236', N'37901016195')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1651c8a5-2942-4943-aaae-801528686932', N'Benjamín', N'Delgado', CAST(N'2005-07-26' AS Date), N'2190412458', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'13770', N'30151080976')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'16888e4e-7591-48d2-a44f-e0939397f844', N'Nacho', N'Moreno', CAST(N'2000-06-22' AS Date), N'8422069501', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'11265', N'36947699492')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'168b0c0c-da67-4c61-b9d9-d672906972a9', N'Jose', N'Castillo', CAST(N'2011-08-05' AS Date), N'3210514278', N'5526D776-861B-4085-9B5F-91D58221D161', N'34096', N'32290043968')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'16ad4731-532d-40b2-a37f-3d0384c379f3', N'Sandra', N'Ortega', CAST(N'2001-11-07' AS Date), N'4564630515', N'27C89018-0534-480C-B719-5498EEE22D77', N'37476', N'36292825152')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'16dc8109-535f-4d26-99aa-f15c63a9f5a4', N'Ariadna', N'Andres', CAST(N'2001-07-06' AS Date), N'9083717892', N'5526D776-861B-4085-9B5F-91D58221D161', N'78949', N'31102380645')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'16f40924-0bcb-484b-bcd6-09bc07c08918', N'Jose miguel', N'Lorenzo', CAST(N'2016-03-12' AS Date), N'8291809299', N'5526D776-861B-4085-9B5F-91D58221D161', N'87492', N'38994937941')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'16f71261-d627-4c78-a515-f1d95e106163', N'Fran', N'Munoz', CAST(N'2005-11-26' AS Date), N'4805048629', N'5526D776-861B-4085-9B5F-91D58221D161', N'86947', N'35841481990')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'17250bcb-3222-4c47-84dd-f9ef82be931c', N'Andrés', N'Crespo', CAST(N'2020-03-10' AS Date), N'8852819916', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'96814', N'39727888082')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1756e880-2645-4a8d-913f-7a444e38c28e', N'Cipriano', N'Flores', CAST(N'2005-10-04' AS Date), N'0509603974', N'5526D776-861B-4085-9B5F-91D58221D161', N'94669', N'32259286498')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1786461a-03db-4fae-a2f4-652335fdb5dc', N'Mirella', N'Herrero', CAST(N'2007-03-06' AS Date), N'9105727620', N'27C89018-0534-480C-B719-5498EEE22D77', N'89191', N'34606557401')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'17c9153a-1370-4980-8206-9d5b5c79a899', N'Juan Carlos', N'Merino', CAST(N'2015-09-25' AS Date), N'0043458750', N'27C89018-0534-480C-B719-5498EEE22D77', N'52569', N'34561070456')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'17cf680d-072a-49f0-9cbf-c90413645977', N'Ernestina', N'Bravo', CAST(N'2019-01-15' AS Date), N'4611720421', N'5526D776-861B-4085-9B5F-91D58221D161', N'59419', N'36191294800')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'180dc6d6-ebfc-4087-aa06-c3838eaf860f', N'Cortez', N'Soto', CAST(N'2017-10-23' AS Date), N'5691430807', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'40053', N'38600929880')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1810b38d-7220-4e90-8fd6-4adcdfbd7552', N'Malvolio', N'Garcia', CAST(N'2004-08-08' AS Date), N'5636819431', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'04479', N'39564710539')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'188154c0-a290-4962-97d3-9e2e0d748537', N'Nemesio', N'Montero', CAST(N'2014-09-06' AS Date), N'7778248067', N'5526D776-861B-4085-9B5F-91D58221D161', N'71572', N'30530990242')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'189647b1-253d-4904-8466-14873fbe7a82', N'VICTOR', N'Alvarez', CAST(N'2003-08-04' AS Date), N'6187984330', N'27C89018-0534-480C-B719-5498EEE22D77', N'60838', N'37549499980')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'18983075-43e0-4e93-97b2-2abf12b8fe2c', N'Angel', N'Cortes', CAST(N'2007-10-18' AS Date), N'5179346532', N'5526D776-861B-4085-9B5F-91D58221D161', N'24017', N'37767586653')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'18a003a2-a382-4b3a-b937-17d1258193b1', N'Jair', N'Prieto', CAST(N'2002-11-29' AS Date), N'0560955729', N'27C89018-0534-480C-B719-5498EEE22D77', N'39807', N'38230752869')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'18b3c289-6fe9-4607-accb-55015bb930cf', N'Jerónimo/Gerónimo', N'Marquez', CAST(N'2002-03-13' AS Date), N'8939012804', N'5526D776-861B-4085-9B5F-91D58221D161', N'40895', N'32865732747')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'18e55f96-d5e1-4c0e-9558-db7525411356', N'Carito', N'Nieto', CAST(N'2016-07-03' AS Date), N'9870769473', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'98390', N'37777098400')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'18eb97ba-12e1-4406-a97e-d8a00f4d679b', N'Miguela', N'Arias', CAST(N'2005-03-13' AS Date), N'5090575526', N'27C89018-0534-480C-B719-5498EEE22D77', N'52434', N'32046234912')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'190becf1-e2e6-4d4d-ab11-e1301fcab5c8', N'Neron', N'Santos', CAST(N'2019-07-23' AS Date), N'1227297164', N'5526D776-861B-4085-9B5F-91D58221D161', N'06041', N'36881072166')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'192d7a66-33f9-410f-a972-e73f7e18af0a', N'Ricardo', N'Garcia', CAST(N'2018-09-11' AS Date), N'4548366424', N'27C89018-0534-480C-B719-5498EEE22D77', N'64081', N'32488563513')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'19623ec3-50bb-4b40-84c2-17f711ad31d3', N'Alicia', N'Delgado', CAST(N'2001-10-21' AS Date), N'1654691191', N'27C89018-0534-480C-B719-5498EEE22D77', N'66039', N'37776525113')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'197ead55-9fd5-4d09-b616-2c2fc67eb7cb', N'Adelina', N'Prieto', CAST(N'2006-03-24' AS Date), N'7890526297', N'27C89018-0534-480C-B719-5498EEE22D77', N'84886', N'33616271943')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'19967463-4f5e-4ec1-a9a6-ad8439189c98', N'Lilia', N'Andres', CAST(N'2000-09-11' AS Date), N'3364341928', N'27C89018-0534-480C-B719-5498EEE22D77', N'56133', N'30578309127')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'19a5921f-b871-49e0-8122-99e090d7aaaa', N'Jesús', N'Aguilar', CAST(N'2003-12-03' AS Date), N'2860748170', N'27C89018-0534-480C-B719-5498EEE22D77', N'38063', N'34630779416')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'19c913fb-0d04-4fdb-b4ac-5ee164db946b', N'Jesús', N'Pardo', CAST(N'2001-12-11' AS Date), N'9547157479', N'5526D776-861B-4085-9B5F-91D58221D161', N'19009', N'35114426719')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1a1e528f-b6fe-4510-88f5-7f5ddc8357e4', N'Alejandro', N'Sanz', CAST(N'2019-07-20' AS Date), N'5318982681', N'5526D776-861B-4085-9B5F-91D58221D161', N'76064', N'32697939443')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1a6ade28-77b2-40b8-82ec-d9e4093d6640', N'Max', N'Diaz', CAST(N'2020-12-09' AS Date), N'3638674474', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'44586', N'37755968889')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1a829826-37fd-4023-be94-c333463180d8', N'Dionisia', N'Fuentes', CAST(N'2012-07-31' AS Date), N'1660482487', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'36561', N'35873491952')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1a95b53f-1e06-4d8a-81c8-f43bb0887ea7', N'Ander', N'Flores', CAST(N'2003-05-05' AS Date), N'5206913951', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'42379', N'38592676919')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1ac9e20a-65e6-423d-b7a3-ab1cbe6d4739', N'Jorge', N'Reyes', CAST(N'2001-01-11' AS Date), N'3172216292', N'5526D776-861B-4085-9B5F-91D58221D161', N'83583', N'38967950743')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1ad7eae1-0dfc-400f-8e64-2d8a0f5d68af', N'Martín', N'Mora', CAST(N'2012-08-30' AS Date), N'1001675472', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'08022', N'37948507621')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1add44ea-f993-4040-a41c-795fc188b5ef', N'Shizuko', N'Garrido', CAST(N'2002-05-27' AS Date), N'3851820419', N'5526D776-861B-4085-9B5F-91D58221D161', N'02997', N'39494043499')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1af2a4fe-ebd2-422e-b33e-07e730136f05', N'Paz', N'Garrido', CAST(N'2009-08-08' AS Date), N'5369243600', N'5526D776-861B-4085-9B5F-91D58221D161', N'93817', N'38486400789')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1b09a441-95e1-4596-a176-e97411cdec99', N'Lola', N'Romero', CAST(N'2021-09-27' AS Date), N'2024483445', N'5526D776-861B-4085-9B5F-91D58221D161', N'21770', N'35170335069')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1b215b0c-851f-4725-b96a-1545d962f911', N'Macario', N'Medina', CAST(N'2000-02-25' AS Date), N'8999962201', N'5526D776-861B-4085-9B5F-91D58221D161', N'52942', N'38581732653')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1b3eb3c5-e8b1-44de-83d4-b2ff49fc702a', N'Citlali', N'Mora', CAST(N'2011-06-08' AS Date), N'9311401162', N'27C89018-0534-480C-B719-5498EEE22D77', N'56046', N'31751845616')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1b7b4c58-7302-42f9-8411-e1f17658c070', N'Miguel', N'Sanchez', CAST(N'2015-06-30' AS Date), N'5330182620', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'61248', N'34398430933')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1b7e6cd2-0551-4423-9ad4-d9e62b969b31', N'Lolita', N'Gimenez', CAST(N'2014-11-06' AS Date), N'9912063183', N'27C89018-0534-480C-B719-5498EEE22D77', N'00721', N'30557526030')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1bbc2801-c9af-49bf-a98e-d657396ad95c', N'Julián', N'Merino', CAST(N'2005-06-15' AS Date), N'4481195213', N'5526D776-861B-4085-9B5F-91D58221D161', N'34062', N'30508176808')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1bc3fdff-da21-4e3f-865c-ea4b7cf13011', N'Jerrold', N'Marcos', CAST(N'2003-10-24' AS Date), N'8461213180', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'55169', N'36665496552')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1bf162e9-f451-476e-b551-29cf845d131e', N'Milagros', N'Castillo', CAST(N'2011-04-25' AS Date), N'7689029683', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'93568', N'35099028291')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1c5073f3-ace1-4cde-b72a-119df77a5177', N'Montenegro', N'Perez', CAST(N'2016-07-24' AS Date), N'6947033098', N'5526D776-861B-4085-9B5F-91D58221D161', N'77755', N'36747891850')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1c70425b-a3b4-4379-8950-8e3f9fbebc66', N'Julen', N'Moya', CAST(N'2005-12-26' AS Date), N'7104344917', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'91734', N'31310183025')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1c775b52-87f7-453f-838e-3b78534a5fa6', N'David', N'Munoz', CAST(N'2016-04-26' AS Date), N'0171652550', N'5526D776-861B-4085-9B5F-91D58221D161', N'68719', N'32657291823')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1c7d23b0-a2e4-4913-b1d3-eb0b8ba350f9', N'Camilo', N'Morales', CAST(N'2000-11-28' AS Date), N'1645908057', N'27C89018-0534-480C-B719-5498EEE22D77', N'25570', N'35036572631')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1cad51c9-6dc1-46a3-a89b-a832d444bf70', N'Lía', N'Vazquez', CAST(N'2016-12-10' AS Date), N'5021761138', N'5526D776-861B-4085-9B5F-91D58221D161', N'01211', N'33820038498')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1cc52e24-0173-4141-b654-c5c8542b28db', N'Roberto', N'Prieto', CAST(N'2012-08-17' AS Date), N'6418499478', N'5526D776-861B-4085-9B5F-91D58221D161', N'32850', N'38778710223')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1cd0f80d-ff40-463a-b7c4-6a313d069518', N'Cisco', N'Pastor', CAST(N'2003-09-12' AS Date), N'7932534885', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'81166', N'31946466077')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1cef41cf-a4da-4b7e-ba26-28b78f3bc4c8', N'Cobura', N'Soto', CAST(N'2002-02-28' AS Date), N'2121395901', N'5526D776-861B-4085-9B5F-91D58221D161', N'99891', N'32289183041')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1d178747-064d-4345-93ab-7ccbe3c31ade', N'Felisa', N'Leon', CAST(N'2002-08-03' AS Date), N'1783214101', N'27C89018-0534-480C-B719-5498EEE22D77', N'84668', N'32836886514')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1d1b5ed8-266a-4e46-ba76-c19a14c42054', N'Aurora', N'Perez', CAST(N'2014-02-04' AS Date), N'2324829662', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'46717', N'36723562842')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1d4c9790-1b11-460f-a3d9-8d78465447e1', N'Rut', N'Rubio', CAST(N'2020-02-20' AS Date), N'9787520425', N'5526D776-861B-4085-9B5F-91D58221D161', N'26599', N'30881609800')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1d4ee040-5b87-45c2-ba39-d310008d6ea9', N'Asunción', N'Perez', CAST(N'2017-08-27' AS Date), N'3949565576', N'27C89018-0534-480C-B719-5498EEE22D77', N'59564', N'32174288442')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1de852c1-eb9e-43fe-9f2a-10cb23819484', N'Mireya', N'Menendez', CAST(N'2006-02-09' AS Date), N'5324767573', N'5526D776-861B-4085-9B5F-91D58221D161', N'09181', N'38221889114')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1dfe9a71-f21f-470b-b825-a01ea14194f7', N'Juan Felipe', N'Iglesias', CAST(N'2002-09-08' AS Date), N'3664306876', N'27C89018-0534-480C-B719-5498EEE22D77', N'34262', N'30150137273')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1e3593d9-8ad0-4b12-a598-421d3fe1343f', N'Vanesa', N'Pardo', CAST(N'2019-04-26' AS Date), N'9236192653', N'27C89018-0534-480C-B719-5498EEE22D77', N'38819', N'36210422537')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1e8ebb74-0430-481e-8ff0-955306eff0bf', N'Damián', N'Rubio', CAST(N'2009-08-05' AS Date), N'4734675485', N'27C89018-0534-480C-B719-5498EEE22D77', N'18636', N'33370398985')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1edf4e88-9a82-4a05-8926-eef8b6245c4a', N'Rosario', N'Rey', CAST(N'2000-10-09' AS Date), N'5879973746', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'25962', N'30322021629')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1efc660d-7901-4031-bd20-d76a7b242bd7', N'Geo', N'Marquez', CAST(N'2019-06-17' AS Date), N'4416215675', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'91325', N'31136166285')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1f0cd0c6-ebab-4ada-8c3a-af1d0879ac80', N'Jerónimo/Gerónimo', N'Munoz', CAST(N'2009-12-18' AS Date), N'9533564897', N'5526D776-861B-4085-9B5F-91D58221D161', N'85077', N'32520949985')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1f13da87-6305-495f-a20c-96d0512bc6e1', N'Jacqueline', N'Moya', CAST(N'2013-01-21' AS Date), N'9575314003', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'95654', N'33471377283')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1f42a2a2-c962-4c0d-9509-558696ad54a8', N'Jose', N'Carmona', CAST(N'2000-09-30' AS Date), N'4590713503', N'5526D776-861B-4085-9B5F-91D58221D161', N'72087', N'32337012993')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1f586629-56ac-410d-8344-254ee4ded530', N'Jon', N'Rey', CAST(N'2015-08-22' AS Date), N'7077515758', N'5526D776-861B-4085-9B5F-91D58221D161', N'13220', N'32803280877')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1f778ee8-1c60-401a-9d28-959194ca4eeb', N'Bautista', N'Fuentes', CAST(N'2009-06-11' AS Date), N'1775376088', N'5526D776-861B-4085-9B5F-91D58221D161', N'17877', N'38702782624')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'1fc24569-94dc-4163-ab3f-3aeedab3844d', N'Benjamín', N'Vicente', CAST(N'2011-02-05' AS Date), N'6623894972', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'43889', N'33371013569')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2002fb63-f0a2-4a99-aa85-ecb9a715d234', N'Lourdes', N'Carrasco', CAST(N'2016-07-23' AS Date), N'2647661152', N'27C89018-0534-480C-B719-5498EEE22D77', N'20672', N'31522388096')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2033c63b-5a7f-47ff-ae16-d0b115dc0ec4', N'Paco', N'Cruz', CAST(N'2018-05-03' AS Date), N'1335555754', N'27C89018-0534-480C-B719-5498EEE22D77', N'15223', N'32303530625')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'20522055-dc93-4a10-9397-15060f3774b0', N'Max', N'Vega', CAST(N'2021-10-30' AS Date), N'2417033663', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'77479', N'32301499433')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'208c138a-9301-45bc-bc7a-ba023c54adf3', N'Clotilde', N'Munoz', CAST(N'2000-08-01' AS Date), N'8863544071', N'27C89018-0534-480C-B719-5498EEE22D77', N'89122', N'32737220400')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'208e2b81-510d-4680-97bc-92caf5b0e9a0', N'Nicolás', N'Diaz', CAST(N'2011-04-05' AS Date), N'5360875360', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'34394', N'32113582214')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'209e5528-bb4b-44aa-ac06-399b1b6f472d', N'Jose', N'Gonzalez', CAST(N'2018-02-22' AS Date), N'5785371467', N'5526D776-861B-4085-9B5F-91D58221D161', N'76803', N'32963614167')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'20e7321f-5f9a-4200-a2b4-3d41f1c2b268', N'Diana', N'Alonso', CAST(N'2005-04-22' AS Date), N'2041077652', N'27C89018-0534-480C-B719-5498EEE22D77', N'63568', N'32640507279')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'21253b18-97aa-41e6-8650-608692a34ea6', N'Nuria', N'Saez', CAST(N'2019-11-10' AS Date), N'0906734175', N'5526D776-861B-4085-9B5F-91D58221D161', N'86897', N'39380810746')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'21696759-c7b6-4807-9f78-62733dd89b81', N'Úrsula', N'Garcia', CAST(N'2019-08-16' AS Date), N'9213264427', N'27C89018-0534-480C-B719-5498EEE22D77', N'98705', N'30902374436')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2173cf2a-72b5-4474-878e-a924beadb389', N'Rafael', N'Saez', CAST(N'2009-01-25' AS Date), N'0555519270', N'5526D776-861B-4085-9B5F-91D58221D161', N'34444', N'37377632593')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'21921c3a-e4b6-43e9-8f85-288cd34dbe93', N'Pedro', N'Flores', CAST(N'2015-08-27' AS Date), N'9092893725', N'27C89018-0534-480C-B719-5498EEE22D77', N'63815', N'35903181777')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'219aa258-2bab-4ef1-90b7-6146d7d69484', N'Arantxa', N'Caballero', CAST(N'2001-11-18' AS Date), N'9123237043', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'87351', N'37933868858')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'219e96b9-b515-4b61-8761-a60ff0606275', N'Manuel', N'Alonso', CAST(N'2014-10-27' AS Date), N'0672078525', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'38424', N'30302184624')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'21b4bc7d-67ae-4dc4-b2d2-5e40fcb82c56', N'Manu', N'Cruz', CAST(N'2004-06-18' AS Date), N'2245182737', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'37700', N'37216444496')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'21c67b5b-e536-471a-85c8-54ad3fbb79b2', N'Camilo', N'Leon', CAST(N'2014-02-19' AS Date), N'9417588977', N'5526D776-861B-4085-9B5F-91D58221D161', N'59050', N'34164828274')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'21ea171f-bd78-4d96-8304-4615423252e6', N'Jorge', N'Gomez', CAST(N'2001-10-23' AS Date), N'4417895239', N'27C89018-0534-480C-B719-5498EEE22D77', N'88687', N'38559860519')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'223da7a5-a2f0-4b4f-9639-4a3280e47b2b', N'Ramira', N'Gomez', CAST(N'2020-07-28' AS Date), N'6625016817', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'99289', N'39117587218')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2289d16a-e77e-40c2-b33f-233d19e56361', N'Nicolás', N'Arias', CAST(N'2015-09-28' AS Date), N'0939124777', N'5526D776-861B-4085-9B5F-91D58221D161', N'87391', N'31670832739')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'22ae5c40-e2d2-4166-99f2-9bf3ce6aee2a', N'Felipe', N'Mora', CAST(N'2015-07-13' AS Date), N'1295899230', N'5526D776-861B-4085-9B5F-91D58221D161', N'91235', N'33179802992')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'22c20fa5-8c47-44e6-b5e9-cd179a5c1645', N'Dalila', N'Herrera', CAST(N'2013-03-17' AS Date), N'8464710211', N'5526D776-861B-4085-9B5F-91D58221D161', N'33012', N'30316179897')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'22c23207-b77d-410e-9f6a-5ac5f9c4a4bb', N'Shizuko', N'Name', CAST(N'2013-12-07' AS Date), N'9560175692', N'27C89018-0534-480C-B719-5498EEE22D77', N'01876', N'33525280809')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2321a5dd-aed0-4ba7-9237-c8b420def207', N'Agustina', N'Hernandez', CAST(N'2004-08-31' AS Date), N'9545483176', N'27C89018-0534-480C-B719-5498EEE22D77', N'25124', N'36541590182')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'23250980-df4a-4b9f-b0bc-c75965ecaf68', N'Luis', N'Mendez', CAST(N'2011-09-16' AS Date), N'8031334713', N'27C89018-0534-480C-B719-5498EEE22D77', N'78292', N'35820589151')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2329f55a-22fc-4b8f-9b51-addc95b5fbac', N'María', N'Arias', CAST(N'2000-10-28' AS Date), N'8309371499', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'48455', N'36510310079')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'233fe2a2-7b1a-4336-aa1f-e679133f9c7d', N'Kiki', N'Martin', CAST(N'2009-08-24' AS Date), N'2758785810', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'97999', N'35891671750')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'23fa8e23-d271-4477-b5dd-d225badb04dc', N'Dalila', N'Fuentes', CAST(N'2002-09-15' AS Date), N'5660705168', N'27C89018-0534-480C-B719-5498EEE22D77', N'36443', N'34529401740')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'24328736-4fcd-41da-827d-5fa24018655f', N'Ramira', N'Martin', CAST(N'2001-08-02' AS Date), N'2976687536', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'99655', N'37844308639')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2481c311-f0af-4b83-bee8-efbe83e447f5', N'Jose miguel', N'Cano', CAST(N'2014-03-14' AS Date), N'1551168171', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'33572', N'34433071348')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'248f517d-965d-4b64-a137-203234cc5d4e', N'Ignacio', N'Campos', CAST(N'2008-07-13' AS Date), N'7904760956', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'61111', N'31275693897')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'24abf8bd-ca5a-46bd-8119-56a4d3280422', N'Haydée', N'Izquierdo', CAST(N'2003-01-25' AS Date), N'0702045781', N'5526D776-861B-4085-9B5F-91D58221D161', N'65370', N'30486423082')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'24b96307-047e-4bfd-a51f-689ae83af0c4', N'Aurora', N'Leon', CAST(N'2016-04-30' AS Date), N'9380929322', N'5526D776-861B-4085-9B5F-91D58221D161', N'25841', N'36879276836')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'24c09fc6-b205-4f06-9aae-d2d998d1616a', N'Amparo', N'Ruiz', CAST(N'2018-06-29' AS Date), N'9042077565', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'07350', N'37038739680')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'24cfb6ef-95cf-4021-a07e-47002891b481', N'Francisco', N'Ortega', CAST(N'2006-06-07' AS Date), N'3144611832', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'33493', N'39780576453')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'24d4bc3d-6220-4004-85ee-b84814851e26', N'Josep', N'Mendez', CAST(N'2008-03-25' AS Date), N'1941438096', N'5526D776-861B-4085-9B5F-91D58221D161', N'37803', N'34552866301')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'24e63cfe-771f-4672-a3e5-2ccd1162db33', N'Luisa', N'Aguilar', CAST(N'2003-07-28' AS Date), N'2893037115', N'27C89018-0534-480C-B719-5498EEE22D77', N'93367', N'37161422710')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'25110091-4c2f-4956-a09d-123b7f78b59c', N'Rodrigo', N'Flores', CAST(N'2006-12-17' AS Date), N'5218991211', N'5526D776-861B-4085-9B5F-91D58221D161', N'39476', N'30267672314')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'252b76f2-2fa0-44cb-8152-9fd2506326c7', N'Sergio', N'Guerrero', CAST(N'2002-11-10' AS Date), N'2132801990', N'27C89018-0534-480C-B719-5498EEE22D77', N'35316', N'32875260288')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2556ade7-354a-4ed2-9f1e-e40534cfa500', N'Jerrold', N'Pardo', CAST(N'2013-04-07' AS Date), N'0733967350', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'81070', N'38898531477')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'255c605e-8a51-439c-9ee7-4ccc4eff5d94', N'Franco', N'Delgado', CAST(N'2007-11-30' AS Date), N'7723509048', N'27C89018-0534-480C-B719-5498EEE22D77', N'84594', N'30038016618')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2591d14a-eb0e-4005-a63a-257a69826c99', N'Gael', N'Vazquez', CAST(N'2014-12-01' AS Date), N'7113949963', N'5526D776-861B-4085-9B5F-91D58221D161', N'96840', N'33377440299')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'25c8c9ab-0804-4594-ae45-5d39f36d60e7', N'Julieta', N'Dominguez', CAST(N'2020-08-25' AS Date), N'0156133665', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'78959', N'38222318195')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'261ae6aa-c209-4893-8913-00669ed946b3', N'Fernando', N'Fuentes', CAST(N'2001-01-02' AS Date), N'8128925199', N'27C89018-0534-480C-B719-5498EEE22D77', N'02947', N'36673495902')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'261b6919-42ae-4e16-a957-422ca17d4203', N'Mar', N'Crespo', CAST(N'2003-12-21' AS Date), N'3361484310', N'5526D776-861B-4085-9B5F-91D58221D161', N'08366', N'31691761196')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2647f7cf-130e-4976-afbe-2e20503ea07e', N'Lolita', N'Dominguez', CAST(N'2017-09-22' AS Date), N'9735142856', N'5526D776-861B-4085-9B5F-91D58221D161', N'70412', N'33499217965')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2652dbe0-697d-41df-ade5-e6da01c908ab', N'Esteban', N'Ferrer', CAST(N'2015-01-10' AS Date), N'9658921571', N'5526D776-861B-4085-9B5F-91D58221D161', N'18119', N'38214904220')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'26674991-5cf4-4b67-bddb-4dbffad51d8c', N'Kevin', N'Alvarez', CAST(N'2010-06-30' AS Date), N'9421329839', N'5526D776-861B-4085-9B5F-91D58221D161', N'83617', N'34864749752')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'26d364ab-4688-475c-816a-5f2babde16ef', N'Christopher', N'Cruz', CAST(N'2005-01-10' AS Date), N'5173561381', N'5526D776-861B-4085-9B5F-91D58221D161', N'11130', N'39753686612')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'26e7f6ae-bd77-4c10-9872-b632e4d42fe9', N'Neron', N'Castro', CAST(N'2010-05-29' AS Date), N'7106173845', N'5526D776-861B-4085-9B5F-91D58221D161', N'20571', N'39860746803')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'26ec92fd-ee7d-45c6-a742-8b8b825e696a', N'Marc', N'Vega', CAST(N'2018-01-30' AS Date), N'6632614339', N'27C89018-0534-480C-B719-5498EEE22D77', N'09897', N'35255526721')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'27713d63-6779-4af5-9bb9-25652972af19', N'Jose miguel', N'Pena', CAST(N'2008-10-03' AS Date), N'5650565776', N'5526D776-861B-4085-9B5F-91D58221D161', N'24337', N'38651109782')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'27773054-5325-4f03-a1f5-3ffc458b5841', N'Sebastián', N'Alonso', CAST(N'2006-12-12' AS Date), N'9339782788', N'5526D776-861B-4085-9B5F-91D58221D161', N'74053', N'34734399976')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2784e92b-0f16-4272-a788-b69b70245e58', N'Josué', N'Mora', CAST(N'2018-01-27' AS Date), N'7895908572', N'27C89018-0534-480C-B719-5498EEE22D77', N'57303', N'34322141422')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'27aba9ea-59bf-4103-9aeb-b199335a9fb5', N'Cobura', N'Mora', CAST(N'2009-12-17' AS Date), N'2382255947', N'27C89018-0534-480C-B719-5498EEE22D77', N'28480', N'35453633075')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'27f72e73-889d-4043-a4e1-b9d4184fd2ca', N'Dario', N'Aguilar', CAST(N'2020-11-05' AS Date), N'4100181167', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'52930', N'37420485100')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'289cb105-b1c7-4527-be2d-ff9621307966', N'Felicidad', N'Ramirez', CAST(N'2006-06-20' AS Date), N'9444629406', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'11742', N'39649975440')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'28a0b125-640b-4638-a46f-9b6fbe7ce730', N'Montego', N'Martinez', CAST(N'2020-03-09' AS Date), N'1354592339', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'63289', N'34005466636')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'28d5b307-f83e-4781-96ee-1303d3fa073e', N'Juan Sebastián', N'Ramirez', CAST(N'2003-06-29' AS Date), N'7515182801', N'5526D776-861B-4085-9B5F-91D58221D161', N'88777', N'31747372619')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'28dc350f-2430-4f8e-9ded-1ea1088d4d36', N'Almudena', N'Morales', CAST(N'2002-04-21' AS Date), N'8494101975', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'19858', N'34053000592')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'28f181b1-6d7c-41dd-9f1c-f15a220ab186', N'Uxue', N'Ruiz', CAST(N'2011-01-30' AS Date), N'9474013946', N'27C89018-0534-480C-B719-5498EEE22D77', N'12635', N'39929436194')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'296193bf-b3db-4010-93b6-b80e2a22d03c', N'Juan David', N'Ortiz', CAST(N'2005-01-01' AS Date), N'8988167237', N'27C89018-0534-480C-B719-5498EEE22D77', N'42079', N'34060519810')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2977dabb-7d63-4822-bfb8-e5a28407a263', N'Ginebra', N'Dominguez', CAST(N'2002-12-29' AS Date), N'0577444172', N'27C89018-0534-480C-B719-5498EEE22D77', N'46316', N'39019135957')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'29adcffa-a4e7-40e5-b3fc-566da0f67f2e', N'Ximen', N'Perez', CAST(N'2019-11-26' AS Date), N'3909916529', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'73906', N'36434121303')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'29b9d772-08a7-4477-8631-82740aa41650', N'Neron', N'Garcia', CAST(N'2006-09-02' AS Date), N'3867084159', N'27C89018-0534-480C-B719-5498EEE22D77', N'13252', N'36392724625')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'29e4302a-31db-4caf-b0d8-523c67d3bc34', N'Águeda', N'Castillo', CAST(N'2016-12-22' AS Date), N'6660572188', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'76276', N'38908699975')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'29fc3e2c-e5da-4b42-b65b-47e6345b6ec2', N'Franco', N'Reyes', CAST(N'2001-02-02' AS Date), N'3800571574', N'27C89018-0534-480C-B719-5498EEE22D77', N'81116', N'38224893496')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'29fc893c-abf7-46fa-b928-380984a64dda', N'Loredo', N'Martin', CAST(N'2000-01-27' AS Date), N'2687438012', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'97625', N'36537309906')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2a195487-d87c-4669-87fa-61019ad9b63a', N'Maite', N'Gimenez', CAST(N'2016-01-10' AS Date), N'9424071746', N'5526D776-861B-4085-9B5F-91D58221D161', N'01603', N'33240007136')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2a26c1f0-5ad4-450e-ba17-36bfeaad173f', N'Agustín', N'Montero', CAST(N'2003-07-15' AS Date), N'0732466334', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'08106', N'38357081932')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2a29cce3-7088-48f7-8c11-e0e744fdcbba', N'David', N'Nieto', CAST(N'2001-02-19' AS Date), N'1130129457', N'27C89018-0534-480C-B719-5498EEE22D77', N'21819', N'38850041543')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2a2ee16e-8a10-481d-8526-7de5ba375b02', N'Enriqueta', N'Prieto', CAST(N'2018-08-06' AS Date), N'5971397414', N'5526D776-861B-4085-9B5F-91D58221D161', N'80061', N'36473902242')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2a3669af-346b-4433-9b93-4df2f339fbc5', N'Dario', N'Moya', CAST(N'2005-09-10' AS Date), N'5864710714', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'06082', N'34625034521')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2a5bdba8-8e76-487c-a3e8-bfce075b4f0c', N'Lucia', N'Castillo', CAST(N'2000-08-27' AS Date), N'2751382204', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'84654', N'34740597991')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2a5c0091-765b-416b-812e-5a72d4ae27b3', N'Cuba', N'Morales', CAST(N'2021-09-01' AS Date), N'4329201498', N'5526D776-861B-4085-9B5F-91D58221D161', N'63495', N'34458976304')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2a73d46d-1067-4ba9-aedb-7f3a2547b4e3', N'Santiago', N'Mora', CAST(N'2000-02-03' AS Date), N'3776093211', N'27C89018-0534-480C-B719-5498EEE22D77', N'33336', N'38163047048')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2abfa3f2-064e-470c-806b-ec417308a86d', N'Martina', N'Gutierrez', CAST(N'2012-04-25' AS Date), N'4016291894', N'27C89018-0534-480C-B719-5498EEE22D77', N'73355', N'31317848244')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2ae01b9b-625a-4b40-b5af-a27cc87433be', N'Jose miguel', N'Castro', CAST(N'2000-05-25' AS Date), N'3715436927', N'5526D776-861B-4085-9B5F-91D58221D161', N'63264', N'35518296725')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2af20562-e481-4de2-acfa-683e15aa4eed', N'Leonardo', N'Prieto', CAST(N'2008-10-13' AS Date), N'5873357104', N'27C89018-0534-480C-B719-5498EEE22D77', N'66894', N'33535366904')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2b17598c-5337-4150-9490-87e527de0db1', N'Carlos', N'Pascual', CAST(N'2015-07-27' AS Date), N'1511809412', N'27C89018-0534-480C-B719-5498EEE22D77', N'81484', N'33823403202')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2b311238-8385-403c-a981-6de079d38566', N'Ainhoa', N'Moreno', CAST(N'2010-10-06' AS Date), N'9570378174', N'27C89018-0534-480C-B719-5498EEE22D77', N'44714', N'34918245827')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2b36ae2e-6df0-46e0-b7a9-bf54e5b53a5e', N'Silvia', N'Marin', CAST(N'2021-08-30' AS Date), N'0988141730', N'27C89018-0534-480C-B719-5498EEE22D77', N'57387', N'32217041825')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2b4393d2-e8d0-4ec1-8e87-89478b773f18', N'Alberto', N'Blanco', CAST(N'2003-10-09' AS Date), N'0375399095', N'5526D776-861B-4085-9B5F-91D58221D161', N'12698', N'38959327367')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2b5b83f9-2e9a-4fc1-abc2-a00639b87487', N'Javiera', N'Aguilar', CAST(N'2007-03-01' AS Date), N'8932282803', N'5526D776-861B-4085-9B5F-91D58221D161', N'81737', N'33787517235')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2b62ac22-7408-4288-9d38-d7d1064017ea', N'Alondra', N'Soler', CAST(N'2020-05-11' AS Date), N'8365247500', N'27C89018-0534-480C-B719-5498EEE22D77', N'63197', N'37146473906')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2bd62851-a86a-43c1-9f96-5c6467a3b846', N'Daniel', N'Garrido', CAST(N'2017-02-08' AS Date), N'4361731414', N'27C89018-0534-480C-B719-5498EEE22D77', N'64334', N'38288101644')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2c10bdbc-3bdb-4da3-967f-8b688e4c7c3d', N'Florencia', N'Crespo', CAST(N'2021-09-15' AS Date), N'8295085239', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'67464', N'38563283053')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2c115295-3695-4ad0-be51-97ab51bac84c', N'Agustín', N'Ortega', CAST(N'2006-11-26' AS Date), N'1627805734', N'5526D776-861B-4085-9B5F-91D58221D161', N'43411', N'32602654786')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2c1a77c4-dbf0-46b5-895d-3b2b3f6ea8ae', N'Julieta', N'Moreno', CAST(N'2010-01-04' AS Date), N'7913065715', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'49202', N'33674295686')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2c464d5f-1293-448e-92bf-c8011c43066a', N'Jaime', N'Castro', CAST(N'2016-07-04' AS Date), N'4740926067', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'90415', N'30723572822')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2c485ef5-2ec1-4dd5-bcec-d8c4ac8d7e84', N'Nacho', N'Ortega', CAST(N'2019-11-13' AS Date), N'2153508989', N'27C89018-0534-480C-B719-5498EEE22D77', N'40626', N'39296587590')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2c8d34d7-ec96-4cec-bd74-86c38f83976f', N'Patricia', N'Martin', CAST(N'2013-04-09' AS Date), N'0039357379', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'93831', N'34234038872')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2cdc665f-df99-45d7-96f2-f0c4a0455025', N'Simón', N'Marin', CAST(N'2000-04-08' AS Date), N'1858810321', N'27C89018-0534-480C-B719-5498EEE22D77', N'59063', N'36025343785')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2ce73b30-cf98-4799-8a5a-7a7084b47650', N'Adela', N'Diaz', CAST(N'2015-12-30' AS Date), N'0096915692', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'77306', N'35342970795')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2d166164-46d4-4a5e-afc6-53d61302de23', N'Berta', N'Redondo', CAST(N'2002-10-07' AS Date), N'2569849322', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'20621', N'36175604966')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2d35b13c-72fa-4933-973e-bf3c520e7253', N'Fulca', N'Aguilar', CAST(N'2021-10-27' AS Date), N'4361700465', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'13722', N'32459091531')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2d4a222d-96ef-4150-bd84-496b955abf9c', N'Hortensia', N'Cruz', CAST(N'2021-06-04' AS Date), N'5319770386', N'27C89018-0534-480C-B719-5498EEE22D77', N'32442', N'31874318918')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2d8d2277-ce3b-4c69-bcc9-86a75b6e1736', N'Álvaro', N'Castro', CAST(N'2001-04-14' AS Date), N'1010487934', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'44697', N'36037593115')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2d8d51a0-d507-42b3-92eb-b4c57621aa6f', N'Leticia', N'Ibanez', CAST(N'2020-04-17' AS Date), N'8823759429', N'5526D776-861B-4085-9B5F-91D58221D161', N'77973', N'35040863816')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2d94837f-4887-4456-adec-7e125fee37c4', N'Rosa', N'Menendez', CAST(N'2004-10-29' AS Date), N'6979460336', N'27C89018-0534-480C-B719-5498EEE22D77', N'37899', N'34132163645')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2e091772-edb8-4f07-a392-3a3367bce2ba', N'First names', N'Ortega', CAST(N'2009-07-07' AS Date), N'1543207384', N'5526D776-861B-4085-9B5F-91D58221D161', N'77590', N'39173639251')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2e354540-2edb-4b95-be7e-1f4396ae8d1b', N'Lía', N'Marcos', CAST(N'2008-10-21' AS Date), N'0312526439', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'33851', N'34075502961')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2e47df2a-83c9-4c5e-a8f4-46cac4157751', N'Rocío', N'Alonso', CAST(N'2007-01-13' AS Date), N'7721064725', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'48190', N'31142296560')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2e4a0703-7f08-4398-9e2f-7bdaaace3639', N'Esteban', N'Moya', CAST(N'2018-11-05' AS Date), N'8117352734', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'56120', N'37510221958')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2e5458f6-9070-437c-8d14-642143addcca', N'Pablo', N'Gimenez', CAST(N'2003-04-19' AS Date), N'3629733291', N'27C89018-0534-480C-B719-5498EEE22D77', N'06005', N'38657948673')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2e9a6557-d670-4bf1-bc98-0e9aa8191430', N'Araceli', N'Carmona', CAST(N'2001-08-21' AS Date), N'5528342735', N'5526D776-861B-4085-9B5F-91D58221D161', N'53253', N'35211324453')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2eb2d17d-def9-4702-9603-0a03dd00432d', N'Lisandro', N'Rubio', CAST(N'2016-08-17' AS Date), N'7140731425', N'27C89018-0534-480C-B719-5498EEE22D77', N'18202', N'31470330893')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2ec95f60-3df5-466f-b948-e06cf1915b0b', N'Borja', N'Calvo', CAST(N'2001-04-07' AS Date), N'4368343735', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'51017', N'33711403581')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2ed38e73-4897-4f24-b02a-07519b1f458b', N'Flora', N'Rodriguez', CAST(N'2015-10-23' AS Date), N'3402382165', N'27C89018-0534-480C-B719-5498EEE22D77', N'70727', N'35518358389')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2ee3045f-9326-440b-bab5-4b23a28daf09', N'Alonso', N'Ferrer', CAST(N'2002-10-20' AS Date), N'3190162008', N'27C89018-0534-480C-B719-5498EEE22D77', N'65442', N'39081657521')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2f265ccd-0ed5-4a60-8e90-b3ced5c2a00e', N'Gorka', N'Duran', CAST(N'2000-02-07' AS Date), N'2949649393', N'5526D776-861B-4085-9B5F-91D58221D161', N'70626', N'37056141834')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2f5794c2-0564-4c5a-b4fe-b20841639867', N'Ruth', N'Ibanez', CAST(N'2021-07-05' AS Date), N'7557028691', N'5526D776-861B-4085-9B5F-91D58221D161', N'60315', N'34421404603')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2f8b6d2f-8e74-439e-9427-b2b73188d9fd', N'Berto', N'Cano', CAST(N'2011-03-31' AS Date), N'8059160415', N'27C89018-0534-480C-B719-5498EEE22D77', N'98567', N'37047812839')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2fb4982c-536a-4f75-b73e-e28f60d1dbdf', N'Gretel', N'Pena', CAST(N'2013-06-08' AS Date), N'3105564394', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'64213', N'31325606132')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2fbedfca-0182-43e7-8e72-9ebda996c8bd', N'Alonso', N'Soto', CAST(N'2012-11-20' AS Date), N'4332014665', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'35916', N'37116686259')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2fd2d437-2a58-4887-a67c-a445ba945138', N'Mario', N'Martin', CAST(N'2000-07-26' AS Date), N'8456816686', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'55317', N'31015163660')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'2fd6e8e6-c0b7-420f-a93a-70cbfa26b4e0', N'Ramona', N'Castro', CAST(N'2014-07-07' AS Date), N'5615841470', N'5526D776-861B-4085-9B5F-91D58221D161', N'06230', N'38037768789')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3008d2af-2656-422b-b437-665fc59fdacf', N'Jose miguel', N'Fuentes', CAST(N'2006-01-23' AS Date), N'2890213767', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'17257', N'30687818007')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3072cbd6-91c0-4e11-a45a-a1e744a65cc0', N'Javier', N'Dominguez', CAST(N'2012-06-27' AS Date), N'7470366105', N'27C89018-0534-480C-B719-5498EEE22D77', N'82571', N'31173226254')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'30782a8e-e4bf-4289-ba3c-45e155ec5102', N'Facunda', N'Carrasco', CAST(N'2021-09-29' AS Date), N'6039151222', N'5526D776-861B-4085-9B5F-91D58221D161', N'02252', N'32720910585')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'30c14e7d-841b-4b0a-9890-680de3b3ca0e', N'Sara', N'Ferrer', CAST(N'2010-05-25' AS Date), N'4581524432', N'27C89018-0534-480C-B719-5498EEE22D77', N'28162', N'37238624859')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'30c7d09e-1e41-49f4-a584-399aef53ce67', N'Axel', N'Pardo', CAST(N'2005-09-16' AS Date), N'2884502682', N'27C89018-0534-480C-B719-5498EEE22D77', N'91086', N'34784744360')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'30e8c5f0-4e8e-4419-909d-cfa87a260213', N'Anabel', N'Cabrera', CAST(N'2020-06-20' AS Date), N'2181003862', N'27C89018-0534-480C-B719-5498EEE22D77', N'47343', N'33068243897')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'30fd0ae9-720d-4247-9936-7aa274034986', N'Martina', N'Marquez', CAST(N'2021-12-09' AS Date), N'3773280498', N'27C89018-0534-480C-B719-5498EEE22D77', N'28434', N'30429166259')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3101f5d7-ca10-48c8-9f87-0dc100c6b05f', N'Juan', N'Cortes', CAST(N'2021-01-06' AS Date), N'9622935404', N'27C89018-0534-480C-B719-5498EEE22D77', N'19415', N'35958103880')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'31026a62-891c-4afa-a694-3c036cf47f5a', N'Inmaculada', N'Ramos', CAST(N'2007-04-02' AS Date), N'1639653795', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'52455', N'30138207966')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'310f093d-4cd9-4377-bb20-3ddb8da8a83f', N'Almudena', N'Moreno', CAST(N'2002-03-04' AS Date), N'6767931013', N'5526D776-861B-4085-9B5F-91D58221D161', N'68311', N'38198067008')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'31515f8a-cece-48ab-9e13-055bae5cb257', N'Feliciana', N'Leon', CAST(N'2006-02-08' AS Date), N'6936825229', N'5526D776-861B-4085-9B5F-91D58221D161', N'77944', N'36715096691')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3161e2d5-0105-4300-b846-4b9f86a51c73', N'Benjamín', N'Vega', CAST(N'2000-07-24' AS Date), N'1653375778', N'5526D776-861B-4085-9B5F-91D58221D161', N'41379', N'35067204330')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'319e340a-3a49-4acf-867a-3ed51af4ad04', N'Ricardo', N'Moreno', CAST(N'2002-12-07' AS Date), N'0514819721', N'27C89018-0534-480C-B719-5498EEE22D77', N'50852', N'35218758370')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'31b85e82-9304-4e8c-98a5-98549905cc7b', N'Cipriano', N'Cano', CAST(N'2005-08-14' AS Date), N'3594860291', N'27C89018-0534-480C-B719-5498EEE22D77', N'49839', N'34520252512')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'31ee4db3-052f-4dd8-b129-b1a51c0e3981', N'Teresa', N'Perez', CAST(N'2004-01-24' AS Date), N'3856963848', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'38757', N'33069440293')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'32219709-0411-42b9-aeba-dfe0807127e8', N'Berta', N'Ortiz', CAST(N'2009-12-02' AS Date), N'8373817462', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'11634', N'32398488875')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3222dd59-fb87-49ce-b257-ae217d0d8b5e', N'Martita', N'Ferrer', CAST(N'2003-05-17' AS Date), N'4535283193', N'27C89018-0534-480C-B719-5498EEE22D77', N'89326', N'36186819939')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'322d8010-c57a-4259-aaa9-b7aa4cab932b', N'Dimos', N'Rodriguez', CAST(N'2000-08-26' AS Date), N'5639213763', N'27C89018-0534-480C-B719-5498EEE22D77', N'84200', N'35691576835')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3262d0a1-7ffd-4453-867e-4170ea5b733b', N'Santino', N'Gutierrez', CAST(N'2003-11-20' AS Date), N'9015240322', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'54666', N'33214985825')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3296ada4-6429-493f-9aac-46407f6bd650', N'Joaquina', N'Izquierdo', CAST(N'2006-09-15' AS Date), N'2389609242', N'27C89018-0534-480C-B719-5498EEE22D77', N'89344', N'38329745449')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'329f9a31-95f0-4c61-b30d-4d75b287875f', N'Imelda', N'Cabrera', CAST(N'2018-02-17' AS Date), N'9920694763', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'30853', N'33754929591')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'32b09137-53f3-4801-8b70-929f17734c6c', N'Xavion', N'Mendez', CAST(N'2004-01-12' AS Date), N'5377699437', N'27C89018-0534-480C-B719-5498EEE22D77', N'05411', N'36709661785')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'332efbcc-e76a-42ef-b728-03ed5481416b', N'Caleb', N'Pardo', CAST(N'2017-09-16' AS Date), N'6443685200', N'5526D776-861B-4085-9B5F-91D58221D161', N'08210', N'34462260892')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3334ed64-2607-4f41-a330-2ab1e09254fc', N'Xavion', N'Garrido', CAST(N'2019-10-16' AS Date), N'6681394035', N'5526D776-861B-4085-9B5F-91D58221D161', N'65860', N'36991571068')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'33802ef7-75a3-4bce-969c-b69a4211086d', N'Tamara', N'Diez', CAST(N'2006-09-23' AS Date), N'0751986949', N'27C89018-0534-480C-B719-5498EEE22D77', N'57080', N'38843250660')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'33839f80-d93e-4632-bea3-ca6007e82bb9', N'Froilana', N'Vega', CAST(N'2020-09-16' AS Date), N'6657693235', N'5526D776-861B-4085-9B5F-91D58221D161', N'69640', N'32817344747')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'33860116-d146-45b0-9a12-765110aaefb6', N'Marc', N'Vila', CAST(N'2016-11-20' AS Date), N'1309551195', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'40954', N'36569761748')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'33a3f8b0-5348-4327-acc5-9093911492db', N'Alexander', N'Ramos', CAST(N'2017-11-13' AS Date), N'0875277283', N'5526D776-861B-4085-9B5F-91D58221D161', N'25855', N'32237418251')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'33e10eb3-bb01-4a3f-af1b-958127e884cb', N'Adriana', N'Izquierdo', CAST(N'2017-04-07' AS Date), N'9199072563', N'27C89018-0534-480C-B719-5498EEE22D77', N'76058', N'34155561627')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'33fc2139-cc46-4531-b9c7-afd5948f9359', N'Hugo', N'Vila', CAST(N'2014-06-25' AS Date), N'9623778064', N'5526D776-861B-4085-9B5F-91D58221D161', N'21954', N'39851904141')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3405c6ed-f615-40eb-8775-8825de8b86d8', N'Jose luis', N'Gomez', CAST(N'2018-09-16' AS Date), N'2777342708', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'44081', N'30210572625')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'342d12e9-6c46-4d39-93d9-91d864aeb5f3', N'Jon', N'Herrera', CAST(N'2001-07-25' AS Date), N'3474403628', N'27C89018-0534-480C-B719-5498EEE22D77', N'08929', N'37076816939')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'346d208b-7f94-4945-a72a-b3e393025fa4', N'Nuria', N'Lorenzo', CAST(N'2007-07-19' AS Date), N'5106830622', N'27C89018-0534-480C-B719-5498EEE22D77', N'01411', N'37008010351')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'34857636-3686-440d-a7c7-dbfb911c3caf', N'Hernan', N'Ibanez', CAST(N'2016-05-17' AS Date), N'2612884966', N'27C89018-0534-480C-B719-5498EEE22D77', N'79744', N'36314501439')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'349affff-99cb-43f8-affb-7cb2b23fd875', N'Leonor', N'Morales', CAST(N'2019-02-11' AS Date), N'3121550927', N'27C89018-0534-480C-B719-5498EEE22D77', N'77676', N'39912064652')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'34ac11a0-e184-4720-8f58-25af6c359bfa', N'Chaxiraxi', N'Alvarez', CAST(N'2000-06-26' AS Date), N'0546945057', N'27C89018-0534-480C-B719-5498EEE22D77', N'49319', N'39533381957')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'34bb37a3-4d7a-4e05-92bb-e708744349ff', N'Jerónimo/Gerónimo', N'Bravo', CAST(N'2011-02-27' AS Date), N'5379073757', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'07212', N'35360467940')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'34bf65bb-0f6a-44f6-9918-808e353268ec', N'Ivan', N'Montero', CAST(N'2013-08-16' AS Date), N'9539803862', N'27C89018-0534-480C-B719-5498EEE22D77', N'42896', N'39687175158')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'34d84556-65f0-4049-9e31-fecad785076f', N'Dalila', N'Carmona', CAST(N'2012-01-19' AS Date), N'8894805656', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'34245', N'39399494355')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'350b812f-cad5-4c87-80e8-f3113444b393', N'Clotilde', N'Munoz', CAST(N'2002-09-22' AS Date), N'7222857633', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'35928', N'37245281595')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'355828c3-e3c0-4406-b8de-c762bbf20963', N'Jerrold', N'Torres', CAST(N'2013-09-03' AS Date), N'8697584250', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'22693', N'33349623360')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'35a95689-20fc-410d-b097-ddc62a318e75', N'Rodrigo', N'Herrero', CAST(N'2000-06-20' AS Date), N'9449471132', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'13924', N'38653482736')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'35c19882-9304-411f-b8ac-0d26fa6d3049', N'Lorena', N'Cruz', CAST(N'2007-06-04' AS Date), N'9030701266', N'27C89018-0534-480C-B719-5498EEE22D77', N'66952', N'30256735430')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'35d515d8-9f75-46d2-bed5-851fe6fb334d', N'Belén', N'Andres', CAST(N'2005-06-02' AS Date), N'0023328446', N'27C89018-0534-480C-B719-5498EEE22D77', N'24112', N'35748297867')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'35d7e2c4-af6a-4867-8b8f-a94125f8a725', N'Ricardo', N'Ortiz', CAST(N'2020-06-18' AS Date), N'3508822327', N'5526D776-861B-4085-9B5F-91D58221D161', N'77404', N'39787962817')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3632e1e2-cf94-4fc5-840f-db30f0bab692', N'Valentino', N'Ortiz', CAST(N'2001-05-22' AS Date), N'9258585428', N'27C89018-0534-480C-B719-5498EEE22D77', N'64161', N'30606881022')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'365e5672-75b9-49b8-a141-30fdbacca0e8', N'Jesusa', N'Sanchez', CAST(N'2013-03-10' AS Date), N'9173226062', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'05607', N'35761391139')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'367c263b-1659-41a3-925b-d093f58033e3', N'Tiare', N'Andres', CAST(N'2012-03-13' AS Date), N'2163767503', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'27362', N'39888229809')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'36a7fc4d-2cb2-4218-b1de-b71f52a47f14', N'Xeres', N'Blanco', CAST(N'2002-12-25' AS Date), N'2862341812', N'27C89018-0534-480C-B719-5498EEE22D77', N'83120', N'39712249800')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'36b7f0b7-2157-4ed4-8184-f0e689afb48b', N'Arnau', N'Arias', CAST(N'2014-06-26' AS Date), N'4360966482', N'5526D776-861B-4085-9B5F-91D58221D161', N'61122', N'30512214236')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'36d70055-e6e8-4868-919a-71cd4e581638', N'Micaela', N'Munoz', CAST(N'2005-04-29' AS Date), N'7554748244', N'27C89018-0534-480C-B719-5498EEE22D77', N'50047', N'36676296824')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'36daf50c-1205-4e95-af58-f903ea1a1871', N'Felipa', N'Vega', CAST(N'2002-10-25' AS Date), N'2896472380', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'56261', N'38595087392')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'36f5be69-ae66-47db-929f-54da37ca4e48', N'Luciano', N'Marcos', CAST(N'2008-02-04' AS Date), N'5230730781', N'27C89018-0534-480C-B719-5498EEE22D77', N'47916', N'32742171305')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3703e3be-2743-4aee-9b3e-f50dcfadf622', N'Yesenia', N'Fernandez', CAST(N'2018-11-13' AS Date), N'6115248153', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'92809', N'39029033025')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'370a9d90-b9d3-41d3-8241-f0d725309541', N'Miguel Angel', N'Montero', CAST(N'2005-03-27' AS Date), N'2087518361', N'27C89018-0534-480C-B719-5498EEE22D77', N'52392', N'35090960530')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'370e0acf-2733-46d6-a6fa-27229b27ea3e', N'Max', N'Vila', CAST(N'2012-03-18' AS Date), N'2716319419', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'55710', N'35399183469')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3716ec80-1c99-45e0-9f5d-d79df07a08eb', N'Jair', N'Menendez', CAST(N'2020-01-10' AS Date), N'1848241666', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'33721', N'38603311992')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'373113ba-b8c6-4001-9a90-84d1343561ec', N'Rosa', N'Soler', CAST(N'2009-09-10' AS Date), N'9216448191', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'75887', N'37803168685')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'37539916-ba70-49cf-a571-216d3facbff1', N'Mar', N'Pena', CAST(N'2006-05-19' AS Date), N'3028654823', N'5526D776-861B-4085-9B5F-91D58221D161', N'23725', N'32902672722')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'37922d17-bb99-4c17-8391-0e1768574752', N'Josué', N'Carmona', CAST(N'2008-11-29' AS Date), N'7805522008', N'27C89018-0534-480C-B719-5498EEE22D77', N'36104', N'36493324133')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'381f6a83-50e5-42bc-ae7a-2e468caf41eb', N'Ulrica', N'Morales', CAST(N'2009-11-05' AS Date), N'9607732450', N'5526D776-861B-4085-9B5F-91D58221D161', N'88694', N'38991441167')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3831b802-3f96-4b6a-8de9-b544493e3147', N'Nacho', N'Reyes', CAST(N'2012-11-12' AS Date), N'4660322560', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'41764', N'38266582521')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'38391147-ddbd-48cb-b085-8a171c49617a', N'Neper', N'Morales', CAST(N'2010-11-23' AS Date), N'1840749829', N'27C89018-0534-480C-B719-5498EEE22D77', N'15268', N'30346442475')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'386e36b0-86a9-4ec1-acb2-f1df3a10f585', N'Enriqueta', N'Santos', CAST(N'2014-11-26' AS Date), N'2979906716', N'5526D776-861B-4085-9B5F-91D58221D161', N'19555', N'34827196685')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'38bba7f2-d16f-46a2-8b95-f6db464bc02f', N'Pedro', N'Gonzalez', CAST(N'2012-05-06' AS Date), N'8459706915', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'11063', N'33775534743')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'38bc562c-d91f-4238-a8b3-3aa79a5b5152', N'Manu', N'Bravo', CAST(N'2014-12-02' AS Date), N'0696950156', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'23862', N'34073277498')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'39319b9b-0949-44f3-9fa3-e74bdf8f058f', N'Eugenia', N'Prieto', CAST(N'2008-03-15' AS Date), N'2127914470', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'04322', N'33139308778')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'395ddbab-bd73-4e09-9cd1-4428b358eb8a', N'Jorge', N'Molina', CAST(N'2010-08-08' AS Date), N'6114893523', N'27C89018-0534-480C-B719-5498EEE22D77', N'89886', N'34598992391')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'396a27dd-e6ce-42fa-96e2-78c2bea6136a', N'Facundo', N'Martin', CAST(N'2000-07-26' AS Date), N'0576833643', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'29611', N'35537429744')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'397eeea1-5ba5-4695-ad95-3f652e431fb0', N'Cándida', N'Diaz', CAST(N'2014-02-13' AS Date), N'1460922959', N'5526D776-861B-4085-9B5F-91D58221D161', N'53740', N'30070224658')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3980b5ad-6ebf-4ca4-9be5-7519d0ade6cb', N'Dario', N'Rey', CAST(N'2009-03-30' AS Date), N'6167498763', N'5526D776-861B-4085-9B5F-91D58221D161', N'08854', N'32982830371')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'39a21424-e9ea-47c9-b29a-2b0fd79f8e21', N'Lea', N'Hernandez', CAST(N'2015-12-11' AS Date), N'0902519721', N'27C89018-0534-480C-B719-5498EEE22D77', N'07075', N'30057996569')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'39e98727-189e-40a1-83e6-a4095602500f', N'Mila', N'Alonso', CAST(N'2005-01-10' AS Date), N'5272385299', N'5526D776-861B-4085-9B5F-91D58221D161', N'87710', N'33782781871')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3a413d97-f1d3-498b-bf10-b0f3e5a43b16', N'Mari', N'Fernandez', CAST(N'2018-08-28' AS Date), N'8994404602', N'27C89018-0534-480C-B719-5498EEE22D77', N'01448', N'33265008991')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3a467535-7843-4d72-9c4e-e9ca9f53ce01', N'Vicenta', N'Serrano', CAST(N'2020-02-08' AS Date), N'0584179797', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'07849', N'39260880546')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3a5e8450-7c95-4179-b7b6-3b6a480c406f', N'Pepe', N'Carrasco', CAST(N'2001-02-01' AS Date), N'1306154978', N'27C89018-0534-480C-B719-5498EEE22D77', N'47823', N'39631205922')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3a712216-13a9-4876-aee5-d3df3e9da90e', N'Facundo', N'Diez', CAST(N'2019-02-01' AS Date), N'0631876708', N'27C89018-0534-480C-B719-5498EEE22D77', N'12861', N'33865672471')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3a7c1213-0015-426b-adf8-a277e1beee0d', N'Manu', N'Arias', CAST(N'2019-05-27' AS Date), N'2156225793', N'5526D776-861B-4085-9B5F-91D58221D161', N'16561', N'36800280038')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3a8a26d2-4c4b-40ed-9c82-7dc3731bec0b', N'Silvia', N'Redondo', CAST(N'2016-07-26' AS Date), N'7259676151', N'5526D776-861B-4085-9B5F-91D58221D161', N'06010', N'34466263061')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3a996e8d-cf0b-477a-ab52-9f41ef3e48f4', N'Marina', N'Mora', CAST(N'2009-01-31' AS Date), N'7488378736', N'27C89018-0534-480C-B719-5498EEE22D77', N'69389', N'39545791358')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3ad4997f-fb0d-4523-a91d-5c585917b2fb', N'Laura', N'Vidal', CAST(N'2020-05-05' AS Date), N'6129591848', N'27C89018-0534-480C-B719-5498EEE22D77', N'97206', N'30241280519')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3adc87b4-44e5-43bc-a9a2-2dcce42bdef0', N'Tomasa', N'Herrero', CAST(N'2009-09-12' AS Date), N'0816887756', N'27C89018-0534-480C-B719-5498EEE22D77', N'90672', N'32372698078')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3ae2f817-05ac-4814-a22b-2af5169c0746', N'Jon', N'Ramos', CAST(N'2003-01-17' AS Date), N'2311634634', N'5526D776-861B-4085-9B5F-91D58221D161', N'45970', N'31235684727')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3afa2101-9feb-4af6-8347-432b7a04b7aa', N'Mercedes', N'Herrero', CAST(N'2015-12-23' AS Date), N'4774958181', N'27C89018-0534-480C-B719-5498EEE22D77', N'21870', N'30033528103')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3b1562a3-ef2b-4778-8c04-5cb7be6fc8d4', N'Dalila', N'Name', CAST(N'2012-10-05' AS Date), N'5090864879', N'27C89018-0534-480C-B719-5498EEE22D77', N'34527', N'35158708327')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3b315689-e426-493b-b19a-b115692770e8', N'Natalia', N'Ortiz', CAST(N'2013-03-15' AS Date), N'1742190790', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'73715', N'32578307900')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3b42a609-99aa-4309-9e60-3b74afe81e94', N'Noelia', N'Ortega', CAST(N'2010-10-19' AS Date), N'0562982017', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'11033', N'37361754008')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3b4544a1-1a0a-4904-b391-69bc8020693d', N'Dolores', N'Perez', CAST(N'2000-04-16' AS Date), N'0498512854', N'27C89018-0534-480C-B719-5498EEE22D77', N'59863', N'33892412912')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3b5d2cde-2ef1-4c99-b307-a00b9a0a9e67', N'Nemesio', N'Fuentes', CAST(N'2002-09-19' AS Date), N'9881790948', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'12728', N'34296508362')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3b866047-d6ad-472f-bed9-4d11a76cd933', N'Amelia', N'Calvo', CAST(N'2003-12-31' AS Date), N'2335176305', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'74694', N'31651224060')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3bb4e12c-593c-4164-9b38-0415a0a5aeed', N'Jair', N'Blanco', CAST(N'2015-08-03' AS Date), N'5902647431', N'27C89018-0534-480C-B719-5498EEE22D77', N'51137', N'33566228373')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3bdf813c-8a2e-4157-b457-76a7dfebabfd', N'Ángeles', N'Crespo', CAST(N'2012-12-01' AS Date), N'8546604512', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'69389', N'35614165423')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3bf196e9-394f-4222-915e-d0b9a8e1ad5a', N'Rosa', N'Nunez', CAST(N'2013-03-14' AS Date), N'7283632326', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'10081', N'31372509234')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3c15ce32-af05-4aad-9b3d-759f1f70d09b', N'Cipriano', N'Calvo', CAST(N'2015-04-20' AS Date), N'8113812824', N'5526D776-861B-4085-9B5F-91D58221D161', N'35429', N'35681242986')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3c282d33-0938-4bc4-8a6a-387ece59f3c3', N'Karina', N'Nunez', CAST(N'2016-08-30' AS Date), N'7226537055', N'27C89018-0534-480C-B719-5498EEE22D77', N'26017', N'37453705885')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3c38d603-eff0-4aae-94ac-2ae65a0a037e', N'Narcisa', N'Ferrer', CAST(N'2018-11-09' AS Date), N'0549108432', N'5526D776-861B-4085-9B5F-91D58221D161', N'34363', N'39338068435')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3c7b1be0-7ca7-40fb-9d75-1b8f85ddadde', N'Daniela', N'Hidalgo', CAST(N'2012-08-23' AS Date), N'8685762376', N'5526D776-861B-4085-9B5F-91D58221D161', N'59498', N'36219792464')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3c8f3be9-0673-4b1d-9d17-5f378c3b08f2', N'Santino', N'Merino', CAST(N'2020-06-09' AS Date), N'9400177878', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'96692', N'31425103329')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3c8fa6bd-7657-48d7-af45-d7fbdf199ffd', N'Tiare', N'Romero', CAST(N'2015-09-29' AS Date), N'0353593427', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'18530', N'36651818184')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3c9c539f-f3b8-49ab-a15a-6566ac3da544', N'Dayana', N'Cruz', CAST(N'2010-11-29' AS Date), N'9609998146', N'27C89018-0534-480C-B719-5498EEE22D77', N'91067', N'32993600986')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3ca19571-a87f-4e9a-9fb9-d2c1ab6baeb5', N'Agustina', N'Ruiz', CAST(N'2014-01-29' AS Date), N'1412904539', N'27C89018-0534-480C-B719-5498EEE22D77', N'17568', N'31766093270')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3cc2c73d-700a-405e-843a-18a50f130a4f', N'Carmen', N'Mora', CAST(N'2014-08-06' AS Date), N'0730074384', N'27C89018-0534-480C-B719-5498EEE22D77', N'57669', N'37049373617')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3d039c73-9dd8-40d2-95c7-34493fe660ed', N'Ainoa', N'Andres', CAST(N'2002-10-03' AS Date), N'0286001229', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'17063', N'38089839650')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3d319a74-8e1a-46ce-81b7-4d79688f6887', N'Zenon', N'Gimenez', CAST(N'2007-12-02' AS Date), N'5908563519', N'27C89018-0534-480C-B719-5498EEE22D77', N'09981', N'35891699688')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3d5b6be1-ba97-4403-9451-bc9cf5ca421d', N'Plga', N'Aguilar', CAST(N'2019-03-01' AS Date), N'2083713364', N'5526D776-861B-4085-9B5F-91D58221D161', N'50736', N'34426864812')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3d89d6d6-c41d-4cd0-9fb6-337d74c82b1d', N'Paloma', N'Carrasco', CAST(N'2008-01-27' AS Date), N'2061447322', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'29595', N'36615033664')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3ddc4d31-6ca8-4722-a5a0-25a5503f1894', N'Bautista', N'Hernandez', CAST(N'2018-06-18' AS Date), N'8664481009', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'88144', N'32717487867')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3df2baa2-f55b-4d0d-bd73-b401b83562b4', N'Salvador', N'Reyes', CAST(N'2008-11-06' AS Date), N'7060595835', N'5526D776-861B-4085-9B5F-91D58221D161', N'70913', N'39316770290')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3e38cf71-11f6-4b3b-ad33-c52274959c4e', N'Irene', N'Nunez', CAST(N'2004-07-01' AS Date), N'8083410985', N'5526D776-861B-4085-9B5F-91D58221D161', N'85470', N'39085090602')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3e6dd056-09db-43ed-814f-410c8537e3f4', N'Montel', N'Ferrer', CAST(N'2020-06-07' AS Date), N'5412561198', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'54512', N'39618842920')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3e836ad1-fccf-480d-ac99-a4070618f94f', N'Alondra', N'Vazquez', CAST(N'2004-01-22' AS Date), N'5836776593', N'5526D776-861B-4085-9B5F-91D58221D161', N'76482', N'39762078716')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3e96fd03-3ae7-4715-89e9-d97869bd0954', N'Guillermo', N'Nieto', CAST(N'2007-02-21' AS Date), N'0237078883', N'27C89018-0534-480C-B719-5498EEE22D77', N'30853', N'36413155159')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3eb38ce3-be7e-4675-a1f8-61af729205c2', N'Graciela', N'Mora', CAST(N'2008-09-03' AS Date), N'4374056056', N'27C89018-0534-480C-B719-5498EEE22D77', N'75806', N'31631568246')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3ed15872-db53-4494-b449-5387a14b3a3f', N'Montserrat', N'Torres', CAST(N'2013-07-29' AS Date), N'7697577703', N'5526D776-861B-4085-9B5F-91D58221D161', N'73877', N'35484106538')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3ed670c8-6ef6-41b0-94f5-6fa5f5e495c0', N'VICTOR', N'Flores', CAST(N'2017-12-27' AS Date), N'2923484917', N'5526D776-861B-4085-9B5F-91D58221D161', N'35401', N'37768229160')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3f5c80ca-b2c6-40d0-9825-fc5ee19cb79c', N'Agapetus', N'Marcos', CAST(N'2008-12-02' AS Date), N'7089572931', N'5526D776-861B-4085-9B5F-91D58221D161', N'61399', N'39618505942')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3f69f54a-e944-4b02-bcbf-574d93c981ae', N'Feliciana', N'Iglesias', CAST(N'2021-07-06' AS Date), N'2111581382', N'27C89018-0534-480C-B719-5498EEE22D77', N'06271', N'31138288945')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3fa5cd96-82fa-44a7-a331-38c722ecfb26', N'Noemí', N'Ibanez', CAST(N'2014-03-11' AS Date), N'1675177336', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'50809', N'39482953260')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'3fc7b44f-b2c9-41cf-b689-e21f8bc02f91', N'Gabriela', N'Herrera', CAST(N'2018-01-01' AS Date), N'6243741849', N'5526D776-861B-4085-9B5F-91D58221D161', N'66739', N'33840999675')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'400c9c89-dfe6-49ff-bae3-b41865b7457f', N'Gorka', N'Nieto', CAST(N'2019-08-16' AS Date), N'1153759011', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'81721', N'37608785906')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'40228135-2fd3-4e8a-b91c-b6ad12e989b7', N'Roxana', N'Guerrero', CAST(N'2009-02-19' AS Date), N'2898443504', N'5526D776-861B-4085-9B5F-91D58221D161', N'52536', N'39530536375')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4035efb9-1941-4ddd-80ad-6f3fa30959cc', N'Lorena', N'Calvo', CAST(N'2011-06-24' AS Date), N'7454340317', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'32723', N'37028261831')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'40527922-5aab-46a2-8385-cc47dc54632e', N'Estela', N'Ortega', CAST(N'2006-03-22' AS Date), N'7083752579', N'5526D776-861B-4085-9B5F-91D58221D161', N'74485', N'39196134464')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'405af5ea-4629-43d2-8c2f-b3f8d6698400', N'Antonio', N'Garrido', CAST(N'2016-05-03' AS Date), N'0891626739', N'5526D776-861B-4085-9B5F-91D58221D161', N'99508', N'38744332958')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4062a0bf-7f8c-4ff4-96f9-46bbe5c735d2', N'Frisco', N'Calvo', CAST(N'2021-10-08' AS Date), N'7715809567', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'29668', N'38608634917')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'406d1135-f80c-48d0-8eb4-6f3360303b41', N'Mayte', N'Ruiz', CAST(N'2015-12-26' AS Date), N'2159820393', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'75683', N'39039136524')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'40af45ab-26f3-4ac8-aabc-95c0896d4b33', N'Aina', N'Moya', CAST(N'2020-04-22' AS Date), N'8378062837', N'5526D776-861B-4085-9B5F-91D58221D161', N'12602', N'31561615327')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'40b381d7-bc37-4bbf-aedb-4a5fe8d569ab', N'Ignado', N'Lorenzo', CAST(N'2021-12-21' AS Date), N'1239547482', N'5526D776-861B-4085-9B5F-91D58221D161', N'75201', N'31567434197')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'40b65ca8-c315-429b-b732-d92607e8d51d', N'Paco', N'Ruiz', CAST(N'2000-06-19' AS Date), N'4686090021', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'59591', N'33284216833')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'40c1e462-82c3-4343-8179-e3a221d4f2d8', N'Anabel', N'Saez', CAST(N'2006-01-12' AS Date), N'5982075348', N'27C89018-0534-480C-B719-5498EEE22D77', N'16286', N'36484722129')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'40d92c5f-c405-4262-b789-285107d824ac', N'Clara', N'Saez', CAST(N'2020-06-03' AS Date), N'0059185970', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'99607', N'37473741268')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'40e31d51-5dc8-47a6-a966-a98cb7460dcd', N'Sebastián', N'Serrano', CAST(N'2009-06-29' AS Date), N'8849696232', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'69841', N'31000139222')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'40e4436d-16a9-4985-87c5-6c50ebc166f6', N'Ángela', N'Herrero', CAST(N'2014-01-22' AS Date), N'8919702874', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'82070', N'36552939504')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'40e4da36-b299-49fe-aa27-544cd518eccb', N'Paqui', N'Lorenzo', CAST(N'2000-10-16' AS Date), N'7108327700', N'5526D776-861B-4085-9B5F-91D58221D161', N'48704', N'32333653017')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'40e683b5-e47b-45d8-b935-97a3e8bafff2', N'Antonia', N'Cortes', CAST(N'2009-10-09' AS Date), N'3467385007', N'5526D776-861B-4085-9B5F-91D58221D161', N'25953', N'35542240484')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'40e6d9cf-0685-4a1d-b176-3b0c2ab25861', N'Josefa', N'Ferrer', CAST(N'2015-09-26' AS Date), N'8910346333', N'5526D776-861B-4085-9B5F-91D58221D161', N'23060', N'39011125463')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'41033016-20e7-44b6-9fb7-0ec579bdcf94', N'christian', N'Morales', CAST(N'2005-01-20' AS Date), N'4181334993', N'27C89018-0534-480C-B719-5498EEE22D77', N'83394', N'36858752842')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'41047d03-6ca4-4c40-acbe-0144db2718fa', N'Lupita', N'Moya', CAST(N'2007-08-16' AS Date), N'4623447467', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'89191', N'31074109851')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4123ca12-038f-47d7-8956-a5481dc7c4e7', N'Nemesio', N'Velasco', CAST(N'2016-06-28' AS Date), N'2969987107', N'27C89018-0534-480C-B719-5498EEE22D77', N'36144', N'30786909439')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'413212d9-39c6-465d-9dbc-bd82d0ae6c5c', N'Paula', N'Vega', CAST(N'2021-06-07' AS Date), N'4505082850', N'27C89018-0534-480C-B719-5498EEE22D77', N'35747', N'35155815764')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4142d6e1-bc3b-4dcb-994b-287bf97e802e', N'Max', N'Cabrera', CAST(N'2009-07-21' AS Date), N'6584992566', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'48804', N'32365020210')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'414d3c02-9770-4926-b2b2-763c516bd6dd', N'Isa', N'Velasco', CAST(N'2007-06-04' AS Date), N'8464527613', N'27C89018-0534-480C-B719-5498EEE22D77', N'18384', N'37204072590')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'41709169-0b09-4a3d-82c2-45599d1a1518', N'Ane', N'Suarez', CAST(N'2001-04-01' AS Date), N'6697427082', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'95756', N'31284031868')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'419cacd4-2445-49ba-a7c1-50d720d3ab5f', N'Lara', N'Munoz', CAST(N'2020-11-13' AS Date), N'6141443238', N'27C89018-0534-480C-B719-5498EEE22D77', N'29604', N'31536392511')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4216e04d-7ebe-4d75-90ab-e53a3f190ac4', N'Rosario', N'Pastor', CAST(N'2001-10-23' AS Date), N'3992100245', N'27C89018-0534-480C-B719-5498EEE22D77', N'89774', N'35114801282')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4239280d-d2d4-484b-8da4-9b7f35de7ba0', N'Virginia', N'Prieto', CAST(N'2021-04-19' AS Date), N'8146580912', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'02315', N'35544597632')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'426753b5-89dd-4050-8781-82317b777145', N'Nicolás', N'Guerrero', CAST(N'2001-08-20' AS Date), N'5028282229', N'27C89018-0534-480C-B719-5498EEE22D77', N'61853', N'36577188297')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4298d7f7-13d4-4215-98b9-88e619fe1cdd', N'Jose manuel', N'Rey', CAST(N'2003-03-25' AS Date), N'5997522448', N'27C89018-0534-480C-B719-5498EEE22D77', N'95399', N'39059315365')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'42b8a87b-e36f-4ea9-b37e-cb0b41625c48', N'Vanessa', N'Campos', CAST(N'2014-02-06' AS Date), N'9862913259', N'27C89018-0534-480C-B719-5498EEE22D77', N'81955', N'33428174126')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'42be38de-a997-4dd1-8aad-4f62338d0871', N'José', N'Duran', CAST(N'2015-10-26' AS Date), N'2564632592', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'72894', N'32238630018')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'42c26d95-6551-45df-9fd2-03b0c7fe7f62', N'Josefa', N'Jimenez', CAST(N'2001-09-11' AS Date), N'7422790367', N'27C89018-0534-480C-B719-5498EEE22D77', N'79047', N'31668535774')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'42c6871f-b510-4776-be75-5429972594b5', N'Ruth', N'Vicente', CAST(N'2005-12-16' AS Date), N'2096658775', N'27C89018-0534-480C-B719-5498EEE22D77', N'97692', N'31031335719')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'42dabb85-81ab-4c56-a278-02b73d95d1c5', N'Santino', N'Andres', CAST(N'2001-07-11' AS Date), N'2046443216', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'25954', N'39003568961')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'43130a99-c0e1-472a-ab89-04a27f9ea43e', N'Santiago', N'Diez', CAST(N'2014-07-05' AS Date), N'3558684841', N'27C89018-0534-480C-B719-5498EEE22D77', N'55337', N'35258806981')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4317d01d-32c5-4ee7-b1b7-bdb287680f8c', N'Imelda', N'Marin', CAST(N'2005-08-26' AS Date), N'0357709840', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'87672', N'38601416809')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'43461397-21cd-4e0e-a2f4-5200a1604797', N'Felisa', N'Velasco', CAST(N'2012-08-23' AS Date), N'9466079173', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'67238', N'31235903708')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'43ade2f5-d707-453a-9f32-6f6d7df5bd3d', N'Inma', N'Gomez', CAST(N'2001-06-28' AS Date), N'0043196256', N'5526D776-861B-4085-9B5F-91D58221D161', N'89842', N'32146388568')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'43baf3c4-b635-4c85-ab9e-6af970f016e8', N'Hortensia', N'Hidalgo', CAST(N'2013-09-05' AS Date), N'5593941700', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'43757', N'35994836406')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'43c0b42e-f63a-4fa2-b138-ed55d9996d55', N'Inmaculada', N'Pena', CAST(N'2005-10-26' AS Date), N'5609788074', N'27C89018-0534-480C-B719-5498EEE22D77', N'44170', N'38983295331')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'43c96879-510d-4275-960a-7edcee411bf5', N'Triana', N'Menendez', CAST(N'2017-08-31' AS Date), N'9460491013', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'41187', N'39306182145')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'43d72ab0-fbe3-48ac-89e9-c50c8573f828', N'Pedro', N'Carmona', CAST(N'2018-10-29' AS Date), N'2677940399', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'77853', N'34333746646')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'441611b8-ad46-4c53-bb4f-bbcd2d756f9e', N'Inés', N'Delgado', CAST(N'2005-04-26' AS Date), N'7055300052', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'77298', N'36173764149')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'442ffa90-9e25-4d87-9538-97193c533b5c', N'Ainoa', N'Garrido', CAST(N'2020-04-26' AS Date), N'1903811370', N'5526D776-861B-4085-9B5F-91D58221D161', N'48219', N'36569585756')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'44640c49-2411-4755-8855-b44dd60bddaf', N'Ainoa', N'Delgado', CAST(N'2000-11-09' AS Date), N'2642985101', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'88460', N'30142769869')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'447f3df0-e441-4066-b3a6-6261cca8ac4d', N'Angélica', N'Serrano', CAST(N'2000-08-18' AS Date), N'7854958936', N'27C89018-0534-480C-B719-5498EEE22D77', N'59625', N'39313879896')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'44baf38c-1c1b-4a73-935f-e9cd5857c48e', N'Benita', N'Vidal', CAST(N'2006-12-08' AS Date), N'7374342178', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'47303', N'38823645582')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'44d307e0-28f2-41e3-92ed-31f6b773d46a', N'Micaela', N'Pardo', CAST(N'2008-01-02' AS Date), N'4598457285', N'27C89018-0534-480C-B719-5498EEE22D77', N'43160', N'39042061756')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'44e59d29-792e-46a4-a217-717193ffc903', N'Manolo', N'Name', CAST(N'2017-05-11' AS Date), N'4758699825', N'5526D776-861B-4085-9B5F-91D58221D161', N'53687', N'39105454894')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'44f61941-5f1c-4e2d-a623-54e266a0d98e', N'Jose', N'Mora', CAST(N'2018-01-06' AS Date), N'4834873431', N'5526D776-861B-4085-9B5F-91D58221D161', N'43601', N'33472938472')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4505cc60-595d-410c-89c1-914441a5866f', N'Iván', N'Ramos', CAST(N'2017-09-05' AS Date), N'4147009671', N'5526D776-861B-4085-9B5F-91D58221D161', N'27329', N'32250944550')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'45100205-e638-450b-9e8a-804205d72096', N'Facundo', N'Torres', CAST(N'2011-06-03' AS Date), N'3912848532', N'5526D776-861B-4085-9B5F-91D58221D161', N'89763', N'31566843015')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'452b1cea-a8ad-48f5-811a-08c6f82dceb2', N'Beltran', N'Herrera', CAST(N'2006-01-05' AS Date), N'2872807751', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'57457', N'37932757348')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'452c8bcb-29bb-4eab-9b63-ac8bd74913ce', N'Nasario', N'Perez', CAST(N'2019-07-16' AS Date), N'7719715051', N'5526D776-861B-4085-9B5F-91D58221D161', N'32148', N'30164759990')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'45374285-2224-4217-9d50-9daab7840215', N'Adelina', N'Hernandez', CAST(N'2010-07-12' AS Date), N'5333557400', N'27C89018-0534-480C-B719-5498EEE22D77', N'82053', N'32880857311')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4563647e-9ff6-4492-bc27-b842bfdfaf4f', N'Xabat', N'Torres', CAST(N'2013-11-29' AS Date), N'0408940021', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'43991', N'36614118012')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'456e2f02-3e14-485b-9482-870555a670bf', N'Jesusa', N'Vazquez', CAST(N'2006-09-16' AS Date), N'7395718048', N'27C89018-0534-480C-B719-5498EEE22D77', N'40919', N'30340847692')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'45705763-26da-4d10-9015-82e0113b04d5', N'Carlota', N'Moreno', CAST(N'2007-02-22' AS Date), N'6703430412', N'5526D776-861B-4085-9B5F-91D58221D161', N'58100', N'33639189556')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4570d3f8-9d17-465d-b806-4290f569285e', N'Andy', N'Vicente', CAST(N'2010-04-04' AS Date), N'8580437210', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'28803', N'32366621123')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'45cb26a2-9155-4486-86e4-db882507f70e', N'Lolita', N'Navarro', CAST(N'2020-04-20' AS Date), N'6992035374', N'5526D776-861B-4085-9B5F-91D58221D161', N'04830', N'39516180299')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'45d592fd-d12d-4406-821f-3815da44a7d6', N'Bea', N'Lozano', CAST(N'2005-03-19' AS Date), N'7696615649', N'5526D776-861B-4085-9B5F-91D58221D161', N'64135', N'30232006724')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'465b785d-9168-482d-b28c-f27d859cf306', N'Jennifer', N'Hernandez', CAST(N'2001-12-09' AS Date), N'1768223273', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'57168', N'32871235187')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'46800370-e298-4c2c-9f07-43f01d3a2435', N'Juan', N'Cano', CAST(N'2021-06-07' AS Date), N'1173736106', N'27C89018-0534-480C-B719-5498EEE22D77', N'48487', N'33294238285')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4684f013-3368-4934-919f-de9e8cd0deff', N'Dylan', N'Nieto', CAST(N'2004-06-25' AS Date), N'7993248275', N'5526D776-861B-4085-9B5F-91D58221D161', N'02909', N'33124306336')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'46a42966-ae2c-44f6-86fa-cc0718dcb8a8', N'Sonia', N'Fuentes', CAST(N'2014-05-17' AS Date), N'6877076169', N'27C89018-0534-480C-B719-5498EEE22D77', N'36665', N'31874180908')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'477aa89b-83b5-4945-9adc-90652d277641', N'Asunción', N'Munoz', CAST(N'2008-07-11' AS Date), N'7802528459', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'09042', N'32987918053')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'477fb9fa-9c4a-438f-9472-0f36b2a6b6c6', N'Lautaro', N'Ramos', CAST(N'2007-09-01' AS Date), N'9694706621', N'5526D776-861B-4085-9B5F-91D58221D161', N'75696', N'34816564847')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'47841f71-0cf7-48e7-a8f2-cd08941efb39', N'Franco', N'Castro', CAST(N'2001-03-01' AS Date), N'3601528379', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'16582', N'32529891977')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'47878fdc-f068-4924-991e-823451a2da62', N'Alan', N'Andres', CAST(N'2011-10-19' AS Date), N'3896173602', N'5526D776-861B-4085-9B5F-91D58221D161', N'18232', N'39709208619')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'47bc323a-a2db-449b-8e81-781a4d9ae318', N'María Jesús', N'Cabrera', CAST(N'2002-10-10' AS Date), N'6947097044', N'5526D776-861B-4085-9B5F-91D58221D161', N'73076', N'38783686099')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'47f279bb-6c30-4552-b0a7-c0fad3ef3afd', N'José', N'Munoz', CAST(N'2007-11-09' AS Date), N'9162180987', N'5526D776-861B-4085-9B5F-91D58221D161', N'97360', N'35208549196')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'48122b6f-c20d-4c84-8e6a-affbc6be13d0', N'christian', N'Gil', CAST(N'2016-09-11' AS Date), N'2857280620', N'27C89018-0534-480C-B719-5498EEE22D77', N'26884', N'32228680718')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'48640cf0-84ac-46b7-9605-de62475dbb61', N'Gonzalo', N'Soler', CAST(N'2011-08-12' AS Date), N'6703623500', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'25402', N'32782083600')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'48779103-1727-4e15-83b9-6425e1b5bafb', N'Juan José', N'Marquez', CAST(N'2021-01-20' AS Date), N'9911970145', N'27C89018-0534-480C-B719-5498EEE22D77', N'30291', N'30928240248')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4878258b-2cea-4fee-84b3-bf35457d0b8c', N'Diego Alejandro', N'Arias', CAST(N'2003-09-24' AS Date), N'9636509823', N'27C89018-0534-480C-B719-5498EEE22D77', N'61989', N'39044201986')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'488b315e-ed7e-4d6d-8755-4766077dd43f', N'Rocío', N'Delgado', CAST(N'2009-08-12' AS Date), N'4383579751', N'5526D776-861B-4085-9B5F-91D58221D161', N'75219', N'33883138212')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'48959977-6b8b-45b0-8fae-5917fbf5cf39', N'Cecilia', N'Carmona', CAST(N'2012-07-29' AS Date), N'7588052803', N'5526D776-861B-4085-9B5F-91D58221D161', N'77312', N'38387743159')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'48a2262c-e5d7-4dd6-93d0-393a4742e7dc', N'Julián', N'Menendez', CAST(N'2004-09-03' AS Date), N'3391146902', N'27C89018-0534-480C-B719-5498EEE22D77', N'76997', N'33400287750')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'48b2c659-0495-4efe-8a5d-19228c6e9380', N'Aurora', N'Sanz', CAST(N'2007-04-13' AS Date), N'8360940459', N'5526D776-861B-4085-9B5F-91D58221D161', N'91477', N'30050251232')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'48b46c7e-907b-43f7-8847-8db72de2866f', N'Adelina', N'Saez', CAST(N'2004-09-22' AS Date), N'6797063030', N'27C89018-0534-480C-B719-5498EEE22D77', N'32896', N'30792342622')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'48d6c9d7-b109-444f-a452-94cae5ac70c6', N'Clara', N'Rey', CAST(N'2004-09-28' AS Date), N'7587886020', N'27C89018-0534-480C-B719-5498EEE22D77', N'66538', N'32706476536')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'48e43129-1a49-4c13-ad97-6527e698b5f5', N'Tiare', N'Nieto', CAST(N'2015-12-26' AS Date), N'7530426186', N'27C89018-0534-480C-B719-5498EEE22D77', N'02091', N'33616476007')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'48e864f1-3d99-4678-ab7b-5e8f9d4c3eec', N'Gara', N'Cabrera', CAST(N'2018-10-13' AS Date), N'2725224774', N'27C89018-0534-480C-B719-5498EEE22D77', N'66753', N'39331691031')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'490ecc03-25dd-4494-be9b-b450eea85400', N'Lupita', N'Mora', CAST(N'2006-02-06' AS Date), N'0744785291', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'97235', N'39569347294')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4968477e-7130-4eb3-84de-76bfbde98f82', N'Clàudia', N'Serrano', CAST(N'2019-12-04' AS Date), N'6037321062', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'32198', N'39385505581')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'49e1564d-bf92-47ba-a5ab-16221704723f', N'Luciano', N'Nieto', CAST(N'2021-11-05' AS Date), N'5825379188', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'71260', N'31779417691')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'49f146dd-f1de-4f68-9a5d-3898def4d40c', N'Juan', N'Garrido', CAST(N'2010-09-13' AS Date), N'2149105147', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'88440', N'30811610837')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4a219947-44eb-42f4-8dd1-be958083afd3', N'Maite', N'Rubio', CAST(N'2011-03-31' AS Date), N'9449223222', N'5526D776-861B-4085-9B5F-91D58221D161', N'00225', N'33682867753')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4a332c24-6a0c-4856-aa85-d81722f6d65b', N'adrian', N'Pascual', CAST(N'2010-09-18' AS Date), N'6872759820', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'52340', N'31947734429')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4a3c111e-1703-4c51-94c2-54a77bdafaca', N'Cipriano', N'Hernandez', CAST(N'2001-01-26' AS Date), N'2764481162', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'54994', N'30552524405')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4a6b748f-26d0-467f-b1a3-3be7bb1642ef', N'Fermina', N'Ferrer', CAST(N'2007-04-15' AS Date), N'6204748034', N'27C89018-0534-480C-B719-5498EEE22D77', N'82274', N'31929711689')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4a75ac84-e389-472a-9f9f-604e12a36dae', N'Amaya', N'Perez', CAST(N'2016-10-07' AS Date), N'9466005562', N'5526D776-861B-4085-9B5F-91D58221D161', N'37317', N'34658287294')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4a945f57-3876-4d8a-9337-e10db689977e', N'Carlota', N'Pardo', CAST(N'2000-12-19' AS Date), N'3430109000', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'03246', N'30959449601')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4a9b9cb2-548d-4f9f-8422-3b2fe16bc5a9', N'Julen', N'Navarro', CAST(N'2020-03-30' AS Date), N'9002282725', N'5526D776-861B-4085-9B5F-91D58221D161', N'77036', N'31123985328')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4ad30b66-c54a-478b-a02b-a91c4a20e482', N'Juan Esteban', N'Leon', CAST(N'2004-05-10' AS Date), N'6518617550', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'32890', N'37613736473')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4b76f227-6cdc-474a-8fbc-44c46c509635', N'Alexander', N'Ramirez', CAST(N'2006-11-16' AS Date), N'9696170312', N'5526D776-861B-4085-9B5F-91D58221D161', N'78306', N'36619112626')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4b95db35-3a6c-4b55-ba14-c17dce04402a', N'Luz', N'Leon', CAST(N'2011-05-25' AS Date), N'1105480265', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'72706', N'39665854193')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4ba4a061-5892-4e9f-9aae-491a42925f52', N'Alejandro', N'Carrasco', CAST(N'2018-09-13' AS Date), N'5574055469', N'5526D776-861B-4085-9B5F-91D58221D161', N'17199', N'32141218097')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4ba5a6e6-713e-412b-8aa4-a0d8e7af5e88', N'Sonia', N'Medina', CAST(N'2010-01-01' AS Date), N'4224467461', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'59999', N'35001405195')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4bbc7f9e-7652-494c-8be5-ebf35bc307f2', N'Itahisa', N'Gil', CAST(N'2006-09-01' AS Date), N'7386012745', N'27C89018-0534-480C-B719-5498EEE22D77', N'48348', N'37316379812')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4bbe7092-1f52-48fd-bc36-712f28f0605d', N'Manolo', N'Lozano', CAST(N'2013-03-05' AS Date), N'1263826072', N'27C89018-0534-480C-B719-5498EEE22D77', N'30236', N'39387582597')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4bc39660-ea2a-4b23-b1e8-e565794c4aad', N'Juan David', N'Andres', CAST(N'2003-07-04' AS Date), N'2256272381', N'5526D776-861B-4085-9B5F-91D58221D161', N'00973', N'33256956193')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4befffb6-1864-47d7-8e76-0755e8c88abb', N'Juan Diego', N'Pena', CAST(N'2019-10-23' AS Date), N'7231618385', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'52335', N'32384355688')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4bf19382-f5bc-42eb-8a46-e4bcdd1506a4', N'Nilda', N'Romero', CAST(N'2002-10-25' AS Date), N'1159890037', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'95460', N'39061295327')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4c6eaf64-bc8a-4550-95c1-35b376eb1f6f', N'Alba', N'Morales', CAST(N'2018-03-15' AS Date), N'7647815463', N'5526D776-861B-4085-9B5F-91D58221D161', N'68211', N'34944490823')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4c790fd6-4a60-4d51-8ebe-1bd14782b005', N'Daniel', N'Marin', CAST(N'2006-10-13' AS Date), N'8132542439', N'27C89018-0534-480C-B719-5498EEE22D77', N'19299', N'34440253120')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4c8b9c77-65b9-4ebe-951f-67bc770ef905', N'Juan José', N'Marin', CAST(N'2015-01-27' AS Date), N'1095893271', N'27C89018-0534-480C-B719-5498EEE22D77', N'44501', N'34367099546')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4c90edc8-a36c-4617-9971-4687c5960875', N'Neper', N'Name', CAST(N'2000-03-06' AS Date), N'3979770210', N'27C89018-0534-480C-B719-5498EEE22D77', N'53983', N'34186654052')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4cb5efcf-333a-4492-808e-11b8e3a0dcae', N'Marcelo', N'Pena', CAST(N'2003-02-05' AS Date), N'3999923001', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'21655', N'36477659143')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4ce626a0-abbb-4d9f-b49b-7e1b38646c2e', N'martin', N'Garrido', CAST(N'2008-06-26' AS Date), N'2746026766', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'15107', N'37889525557')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4d0c3f0e-e787-4991-9ca4-2b0eeddd6b06', N'Raul', N'Medina', CAST(N'2021-03-30' AS Date), N'7291118733', N'27C89018-0534-480C-B719-5498EEE22D77', N'94811', N'33750096484')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4d48eca3-1b5c-464e-b732-4281e3058a46', N'Anita', N'Ortega', CAST(N'2006-08-16' AS Date), N'7005354627', N'5526D776-861B-4085-9B5F-91D58221D161', N'08084', N'35971565880')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4d61bb2b-1e5c-4142-a65e-72831fafff75', N'Emmanuel', N'Crespo', CAST(N'2014-11-19' AS Date), N'4457519222', N'5526D776-861B-4085-9B5F-91D58221D161', N'56641', N'36862198735')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4d8c75b0-77c4-4e2d-94b6-6333a5607a1f', N'Belén', N'Bravo', CAST(N'2021-09-02' AS Date), N'0750667594', N'5526D776-861B-4085-9B5F-91D58221D161', N'35030', N'34089106988')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4db37a18-ae59-47ed-ada1-d80259053959', N'Enriqueta', N'Nunez', CAST(N'2011-08-03' AS Date), N'7668863131', N'5526D776-861B-4085-9B5F-91D58221D161', N'74403', N'30325074172')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4db4941b-44bc-4978-bfe2-5c9b7dffd45b', N'Christopher', N'Ramos', CAST(N'2005-04-14' AS Date), N'5302291872', N'27C89018-0534-480C-B719-5498EEE22D77', N'54793', N'36965676079')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4dc44380-b04d-43f3-a325-b1b91db7cc56', N'Feliciana', N'Ramos', CAST(N'2004-05-20' AS Date), N'9215892554', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'55329', N'39898397475')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4ddb5b37-acf9-4b48-a8e3-298379d49e57', N'Mario', N'Prieto', CAST(N'2017-02-18' AS Date), N'6380359341', N'5526D776-861B-4085-9B5F-91D58221D161', N'84598', N'32834878637')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4e601805-e9c8-46e6-983f-fe00421f1f76', N'Ismael', N'Santos', CAST(N'2010-08-28' AS Date), N'3233068163', N'5526D776-861B-4085-9B5F-91D58221D161', N'18406', N'36444976188')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4e67421d-d5ab-4235-8b61-554fb18f427e', N'Facundo', N'Molina', CAST(N'2011-12-18' AS Date), N'7561594100', N'27C89018-0534-480C-B719-5498EEE22D77', N'00022', N'36791745694')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4e7dbff5-d85d-45d7-9d27-3cf044ef4783', N'Itahisa', N'Diaz', CAST(N'2012-02-19' AS Date), N'8057021434', N'5526D776-861B-4085-9B5F-91D58221D161', N'79308', N'34283259820')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4e9c3003-d839-420a-a47e-bc07fb8b51ba', N'Silvia', N'Duran', CAST(N'2019-10-01' AS Date), N'6069128553', N'5526D776-861B-4085-9B5F-91D58221D161', N'20868', N'36149762444')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4eba5544-8b15-4150-a4e5-ce764ea882ac', N'Manuelita', N'Roman', CAST(N'2001-07-18' AS Date), N'2614523537', N'5526D776-861B-4085-9B5F-91D58221D161', N'73789', N'35646042061')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4ed59a60-7f37-4e2f-99a7-cf1ac79744e2', N'Soraya', N'Fuentes', CAST(N'2020-11-25' AS Date), N'7209588314', N'5526D776-861B-4085-9B5F-91D58221D161', N'84159', N'37497507123')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4f319a33-e73a-443a-b2ef-a7c1bef0b60b', N'Jorge', N'Campos', CAST(N'2013-02-23' AS Date), N'8094912648', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'01565', N'36343362653')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4f5f3912-aec7-49bf-a5d5-05966c685c87', N'Xabat', N'Cano', CAST(N'2009-02-03' AS Date), N'4584286656', N'5526D776-861B-4085-9B5F-91D58221D161', N'43818', N'31356711651')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4f627770-be2f-4b62-97b9-c185752e5307', N'Lisandro', N'Garrido', CAST(N'2017-10-02' AS Date), N'3390702232', N'5526D776-861B-4085-9B5F-91D58221D161', N'60445', N'33559649793')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4f76c324-b59d-4538-b15d-951b8ac23879', N'Patri', N'Izquierdo', CAST(N'2010-01-30' AS Date), N'3915430665', N'5526D776-861B-4085-9B5F-91D58221D161', N'53785', N'30978409610')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4f819ec1-45bf-4e11-872d-f5fc4a137f6a', N'Emelda', N'Calvo', CAST(N'2012-09-04' AS Date), N'2509541381', N'27C89018-0534-480C-B719-5498EEE22D77', N'01054', N'30411049249')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'4f8a1938-2660-4026-8c74-f571475c9aa6', N'Jessica', N'Soto', CAST(N'2000-10-01' AS Date), N'4851841574', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'27658', N'30350829813')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'50170402-a206-4508-8827-4231faf8ff06', N'Alex', N'Vazquez', CAST(N'2003-11-24' AS Date), N'6401009236', N'27C89018-0534-480C-B719-5498EEE22D77', N'21900', N'38799864552')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'50196571-bf74-42ed-be64-f848ff864023', N'Sebastián', N'Ramos', CAST(N'2005-05-21' AS Date), N'0380050384', N'5526D776-861B-4085-9B5F-91D58221D161', N'62696', N'32702309905')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'501bd8b3-dc00-4d94-881c-5f2c85c9f5b2', N'Agustín', N'Alonso', CAST(N'2010-02-18' AS Date), N'3143932227', N'5526D776-861B-4085-9B5F-91D58221D161', N'55245', N'32604816320')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'50595eab-eea1-4c2f-8d21-5bc26c51426d', N'Piedad', N'Munoz', CAST(N'2011-03-29' AS Date), N'1766924302', N'5526D776-861B-4085-9B5F-91D58221D161', N'03350', N'33810091537')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5062b182-1ae2-4882-badd-2a4d29d6bfcc', N'Beatriz', N'Alonso', CAST(N'2021-01-24' AS Date), N'0919159398', N'5526D776-861B-4085-9B5F-91D58221D161', N'48011', N'31955488782')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'50921004-09da-466b-910b-686963387144', N'Sergio', N'Izquierdo', CAST(N'2016-12-30' AS Date), N'3019242071', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'89440', N'36909533242')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'509a78ad-2fe2-42b7-b786-e6691acdcffa', N'Frisco', N'Martin', CAST(N'2019-10-01' AS Date), N'0019853356', N'27C89018-0534-480C-B719-5498EEE22D77', N'60435', N'30193521442')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'50b1dd20-74a3-4018-ac02-23dea34c2791', N'Fraco', N'Diaz', CAST(N'2021-01-18' AS Date), N'1642027285', N'27C89018-0534-480C-B719-5498EEE22D77', N'13028', N'33130488614')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'50f88426-3274-49e9-b667-f484c1e2d2a3', N'Victoria', N'Aguilar', CAST(N'2020-10-04' AS Date), N'9584923826', N'5526D776-861B-4085-9B5F-91D58221D161', N'94378', N'34504576110')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'516cbea5-f001-48e9-b02f-afe72540e931', N'Gara', N'Reyes', CAST(N'2008-08-30' AS Date), N'5093036348', N'27C89018-0534-480C-B719-5498EEE22D77', N'95898', N'35364089110')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'518b32d0-0725-4a5d-a406-66b242ceb529', N'Frida', N'Delgado', CAST(N'2019-08-26' AS Date), N'5758883761', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'21030', N'38711914403')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5193b07f-119a-440d-b067-6739b18f4bcb', N'Montserrat', N'Suarez', CAST(N'2007-04-19' AS Date), N'9380073191', N'5526D776-861B-4085-9B5F-91D58221D161', N'67242', N'35361518082')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'521ffb1c-c062-4672-9eec-2201d51005da', N'Zulma', N'Ferrer', CAST(N'2021-01-15' AS Date), N'8595074089', N'27C89018-0534-480C-B719-5498EEE22D77', N'06699', N'32313258272')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'522bc828-da0b-4ed1-9a51-faa966157c1b', N'Lucha', N'Serrano', CAST(N'2016-02-14' AS Date), N'5056989611', N'27C89018-0534-480C-B719-5498EEE22D77', N'56626', N'35088764753')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'522e3167-a8c5-4e11-89f9-d2430c820b2b', N'Cuba', N'Diez', CAST(N'2007-02-11' AS Date), N'3331002670', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'98319', N'36427722613')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'525a3100-6b96-4bb1-90a8-ba8456389a72', N'Sergi', N'Pastor', CAST(N'2004-06-27' AS Date), N'8895111286', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'77352', N'31917567756')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'52729b83-ff68-4cda-8e0b-7d8b1ec15b3a', N'Judit', N'Calvo', CAST(N'2001-11-23' AS Date), N'1095376862', N'27C89018-0534-480C-B719-5498EEE22D77', N'04656', N'34801539049')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'52b7cbc9-1990-4bd8-a9f6-c963c4ef43db', N'Christopher', N'Gomez', CAST(N'2016-10-27' AS Date), N'8852115577', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'86982', N'39004201527')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'52db1a9f-216b-4c2f-9f95-600f0ba1df26', N'Franco', N'Medina', CAST(N'2021-06-01' AS Date), N'6047171296', N'5526D776-861B-4085-9B5F-91D58221D161', N'49513', N'35562030017')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'52f6147e-9b8c-4505-9ab1-dcbec119b70f', N'Hernan', N'Vazquez', CAST(N'2014-10-12' AS Date), N'9069024604', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'07381', N'36700834906')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'52f6800f-562d-43cb-8274-be6027a23ce3', N'Álvaro', N'Cortes', CAST(N'2002-08-29' AS Date), N'6467444024', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'64371', N'31228427946')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'52f9748e-fb1e-47f4-a39e-7c94091b60b7', N'Roberto', N'Marquez', CAST(N'2011-08-06' AS Date), N'4646202482', N'27C89018-0534-480C-B719-5498EEE22D77', N'75105', N'32593580224')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5326ac22-b396-4637-875b-e1d770d813d6', N'Juan', N'Andres', CAST(N'2016-02-24' AS Date), N'8440921336', N'27C89018-0534-480C-B719-5498EEE22D77', N'64119', N'30636910072')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5338912b-7130-4e0b-b961-194bda124969', N'Desamparados', N'Alvarez', CAST(N'2013-03-06' AS Date), N'8701201218', N'5526D776-861B-4085-9B5F-91D58221D161', N'69347', N'31726784916')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'539cc84f-7588-409a-8a0d-a3192b73df00', N'Juan Esteban', N'Ferrer', CAST(N'2007-02-14' AS Date), N'6209574977', N'5526D776-861B-4085-9B5F-91D58221D161', N'23222', N'30386832415')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'53c792f7-220d-4724-8412-488a56681e11', N'Santi', N'Fernandez', CAST(N'2017-10-15' AS Date), N'2227763463', N'5526D776-861B-4085-9B5F-91D58221D161', N'71183', N'33299546662')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'53d340aa-3290-4d7d-8f71-a56bad33d811', N'Eduardo', N'Izquierdo', CAST(N'2008-10-02' AS Date), N'1627539009', N'27C89018-0534-480C-B719-5498EEE22D77', N'43168', N'34658037031')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'53eea3c1-fab6-45b4-97e1-3bb00a0f43a0', N'Malvolio', N'Moya', CAST(N'2002-05-29' AS Date), N'1538452546', N'27C89018-0534-480C-B719-5498EEE22D77', N'55080', N'39512513607')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'53f47010-1f8e-46f6-a619-a03983fa3b06', N'Gael', N'Reyes', CAST(N'2011-12-14' AS Date), N'6537159445', N'27C89018-0534-480C-B719-5498EEE22D77', N'65631', N'34626316782')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5439a4a8-4408-4099-8084-6c63e2389bfc', N'Mariana', N'Carrasco', CAST(N'2020-06-12' AS Date), N'1434827406', N'27C89018-0534-480C-B719-5498EEE22D77', N'98485', N'34805446099')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'54583ee4-341d-4980-9315-7613feea385d', N'Daniel', N'Nieto', CAST(N'2014-03-16' AS Date), N'0143614825', N'27C89018-0534-480C-B719-5498EEE22D77', N'69506', N'34374058102')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'54719be0-9098-467d-bc1c-f34ef23e44bf', N'Antonia', N'Ramirez', CAST(N'2000-04-01' AS Date), N'1460679629', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'78980', N'36027055287')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'54a64162-c463-41d1-b703-f6385a95cff9', N'Jose', N'Ortiz', CAST(N'2007-11-08' AS Date), N'9845976341', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'05747', N'35108958535')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'54ed8338-fb3b-4035-a00f-1949d91c981a', N'Franco', N'Ibanez', CAST(N'2010-04-29' AS Date), N'5031928776', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'04784', N'32656760115')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5559f3de-64d1-4292-a875-591487d7011e', N'First names', N'Fernandez', CAST(N'2003-01-29' AS Date), N'6644328824', N'5526D776-861B-4085-9B5F-91D58221D161', N'54655', N'30625652944')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'556893ae-0fad-4c23-9ece-c12944a23a3e', N'guille', N'Nunez', CAST(N'2010-07-10' AS Date), N'9105543231', N'27C89018-0534-480C-B719-5498EEE22D77', N'70208', N'37719215171')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'55c62a58-1744-415a-96ab-39b2bf8371e3', N'Cortez', N'Morales', CAST(N'2014-08-05' AS Date), N'8107996341', N'5526D776-861B-4085-9B5F-91D58221D161', N'33714', N'38460206607')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'55d9b793-d701-40d8-beb5-6c7ecca02039', N'Hernan', N'Redondo', CAST(N'2005-07-30' AS Date), N'9937331492', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'04633', N'36785860837')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'55f28d70-a670-469c-a9b6-d037ac6ec463', N'Lilia', N'Arias', CAST(N'2012-05-28' AS Date), N'8986711071', N'5526D776-861B-4085-9B5F-91D58221D161', N'42009', N'39831849625')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'561708d2-4cf0-4c1a-a7d3-1ace22106f55', N'Karina', N'Moreno', CAST(N'2004-12-04' AS Date), N'4745274119', N'27C89018-0534-480C-B719-5498EEE22D77', N'26840', N'32790202329')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5627c9cd-2231-4a79-bd82-37df4e7727d0', N'Ángel', N'Mendez', CAST(N'2015-02-05' AS Date), N'7626247054', N'5526D776-861B-4085-9B5F-91D58221D161', N'34234', N'30507996191')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'56426b8b-91bf-41c8-987f-146e447f7db8', N'Javiera', N'Sanchez', CAST(N'2019-05-20' AS Date), N'8180943121', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'92147', N'31951772855')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'56d58040-567a-4eea-a88c-59051b1ea201', N'Alan', N'Duran', CAST(N'2015-12-19' AS Date), N'3229472631', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'40414', N'32528284407')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5716e91e-6acd-41ec-a104-c526b4f71739', N'Lautaro', N'Marquez', CAST(N'2008-10-07' AS Date), N'3882116305', N'5526D776-861B-4085-9B5F-91D58221D161', N'55466', N'37326591784')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'57614e1f-e2dc-4d33-af76-b5394d7c27e7', N'Julen', N'Ruiz', CAST(N'2007-01-04' AS Date), N'5847200083', N'27C89018-0534-480C-B719-5498EEE22D77', N'48413', N'30887723521')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'57920934-336b-4d76-84b6-aae9b4e4b963', N'Leire', N'Soler', CAST(N'2020-10-24' AS Date), N'3930375485', N'27C89018-0534-480C-B719-5498EEE22D77', N'89248', N'38412932037')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'57a5b82e-6769-46b0-a42c-b2c3e32265b4', N'Javier', N'Izquierdo', CAST(N'2010-03-02' AS Date), N'0884827246', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'81826', N'30935456314')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'57c8e6ca-0624-4d8c-ad13-39d53de81f23', N'Borja', N'Hidalgo', CAST(N'2007-02-14' AS Date), N'3642875945', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'15467', N'39399352645')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'57c94b8b-ccf1-47dc-8708-bcca4fea84bb', N'Mari', N'Sanz', CAST(N'2001-06-01' AS Date), N'3059075569', N'27C89018-0534-480C-B719-5498EEE22D77', N'80325', N'39535370680')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'57c9e0a4-984b-470a-a071-659d6b20c894', N'Fanuco', N'Marcos', CAST(N'2010-08-04' AS Date), N'8629101964', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'59820', N'34791938582')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5804e24a-4cb9-42a2-b250-d60eec4cb412', N'Amparo', N'Ramirez', CAST(N'2009-01-06' AS Date), N'8165788171', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'63391', N'32246305378')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'582a7fbe-0e37-43f2-9d4c-efe5d2f89b85', N'Javiera', N'Bravo', CAST(N'2002-12-04' AS Date), N'9041297944', N'5526D776-861B-4085-9B5F-91D58221D161', N'91344', N'34453059299')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5846d30c-6e6d-4d01-ac9a-869462282407', N'Pascuala', N'Navarro', CAST(N'2007-02-28' AS Date), N'8088616151', N'5526D776-861B-4085-9B5F-91D58221D161', N'45547', N'34984326674')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'58a7dfa2-dc6f-4c1e-80f0-07d79098f218', N'Carla', N'Marin', CAST(N'2014-11-05' AS Date), N'9245126333', N'27C89018-0534-480C-B719-5498EEE22D77', N'98660', N'35972667235')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'58b9e128-ac4e-4bdb-a4ec-964c951cb37e', N'Xaverius', N'Gonzalez', CAST(N'2021-09-10' AS Date), N'4921799907', N'5526D776-861B-4085-9B5F-91D58221D161', N'16980', N'30265519469')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'58f5cd97-afae-498b-bf4b-f83ebe8c5fe1', N'Trinidad', N'Sanchez', CAST(N'2000-07-05' AS Date), N'4199598490', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'39213', N'33925599347')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'591a1907-577f-4034-92f6-5bb37efdd8d6', N'Miriam', N'Iglesias', CAST(N'2020-03-15' AS Date), N'4146885346', N'27C89018-0534-480C-B719-5498EEE22D77', N'94590', N'30955422232')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'595314dd-c3cf-4e03-bd0a-446469e65d42', N'Carmen', N'Molina', CAST(N'2019-03-04' AS Date), N'4882805876', N'27C89018-0534-480C-B719-5498EEE22D77', N'29821', N'37604192007')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'596c456e-d5f5-4525-be81-af5695ad6689', N'Alejandra', N'Bravo', CAST(N'2002-03-19' AS Date), N'1052525670', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'29404', N'32581449238')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'59753f51-2c68-4da5-8e36-e41479bfdb74', N'Fernando', N'Ramos', CAST(N'2017-09-02' AS Date), N'2893345021', N'27C89018-0534-480C-B719-5498EEE22D77', N'48119', N'38772770762')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'59a90570-8b6f-438f-9b9b-202675634057', N'Javier', N'Pascual', CAST(N'2012-02-29' AS Date), N'0397248468', N'27C89018-0534-480C-B719-5498EEE22D77', N'67592', N'38453443260')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'59b7cf9a-8f1c-4b29-b19e-226d1a3f2e6b', N'Diego', N'Alonso', CAST(N'2010-07-29' AS Date), N'2090255395', N'5526D776-861B-4085-9B5F-91D58221D161', N'91907', N'34350443441')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'59caaf5e-17ea-426f-ae40-a4fc6e9dd3a9', N'Mila', N'Merino', CAST(N'2020-10-04' AS Date), N'6629075423', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'77749', N'32690950821')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'59e0a212-419a-4d37-8c85-a51a5fd5c5c4', N'Rodolfa', N'Flores', CAST(N'2007-02-12' AS Date), N'0882517155', N'5526D776-861B-4085-9B5F-91D58221D161', N'47511', N'31508251147')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5a121cb2-ca2f-4ce2-bbe7-1be4614be353', N'Fabricia', N'Aguilar', CAST(N'2006-04-19' AS Date), N'9379040211', N'5526D776-861B-4085-9B5F-91D58221D161', N'23258', N'30327880881')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5a1e28bd-8d34-4d6a-8023-b7e2344c709f', N'Mayte', N'Molina', CAST(N'2003-12-18' AS Date), N'9528249474', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'08695', N'30510800970')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5a49b15f-49ff-4ad1-822a-a0618dbffb26', N'Luz', N'Castillo', CAST(N'2021-05-21' AS Date), N'5977501634', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'93477', N'32248048007')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5a595068-aa97-4b7f-8343-3211433a64d9', N'Clara', N'Duran', CAST(N'2010-05-08' AS Date), N'4522052412', N'27C89018-0534-480C-B719-5498EEE22D77', N'06299', N'30901919106')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5ae35579-925b-46e0-94a8-d5e6366c506b', N'Dayana', N'Redondo', CAST(N'2020-12-12' AS Date), N'7239885761', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'36847', N'39293409678')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5b008490-a741-43cc-b753-ff10f4cf19ea', N'Caleb', N'Hidalgo', CAST(N'2005-10-24' AS Date), N'2515474794', N'5526D776-861B-4085-9B5F-91D58221D161', N'12269', N'33505423525')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5b601750-099a-41b4-b301-4d7459c87310', N'Bruno', N'Gonzalez', CAST(N'2002-05-18' AS Date), N'8427006631', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'73356', N'35105679400')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5b613aff-0166-43c1-81d5-7cc7fb639561', N'Ander', N'Marcos', CAST(N'2014-04-14' AS Date), N'9726004312', N'5526D776-861B-4085-9B5F-91D58221D161', N'30400', N'39305718532')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5bac8c90-990b-4829-9a18-b3cf368c9ec2', N'Azucena', N'Ramos', CAST(N'2008-09-07' AS Date), N'0907367061', N'5526D776-861B-4085-9B5F-91D58221D161', N'96645', N'32873447589')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5bce5d2d-745a-4925-ab83-cee36ffbdc39', N'Guido', N'Reyes', CAST(N'2014-12-23' AS Date), N'9903712637', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'93832', N'34490885478')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5c6c83d9-a0b2-45a0-a5c9-eea7916e1604', N'Sonia', N'Gonzalez', CAST(N'2002-02-24' AS Date), N'2544338075', N'27C89018-0534-480C-B719-5498EEE22D77', N'36436', N'33025197496')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5c77bfeb-9a02-444f-be70-2daf88b60509', N'Iván', N'Alvarez', CAST(N'2014-11-01' AS Date), N'7245116145', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'48535', N'33240769829')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5cb70871-6a67-4b32-b2f0-f01b72d9964c', N'Matías', N'Ibanez', CAST(N'2006-03-27' AS Date), N'8547347077', N'27C89018-0534-480C-B719-5498EEE22D77', N'98264', N'37409653525')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5cdcda84-c16d-4570-af94-806812185585', N'Carla', N'Vega', CAST(N'2020-07-10' AS Date), N'5184900197', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'95069', N'33536259394')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5ce237ed-c695-4390-800d-e67eb9cdf9cb', N'Emmanuel', N'Fuentes', CAST(N'2019-04-15' AS Date), N'3832355480', N'5526D776-861B-4085-9B5F-91D58221D161', N'73750', N'31555099071')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5ce8d15f-9d3e-4d5f-ae63-c2b813d9183a', N'Lucía', N'Torres', CAST(N'2007-12-19' AS Date), N'2456306000', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'26350', N'39712795180')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5d13e0e7-b8d5-4453-8a3f-582a7180d0e0', N'Montenegro', N'Alonso', CAST(N'2001-08-19' AS Date), N'5077947802', N'27C89018-0534-480C-B719-5498EEE22D77', N'55137', N'37585281098')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5d46a07c-a3a5-4305-ac0a-47547c266215', N'María Magdalena', N'Name', CAST(N'2013-09-20' AS Date), N'1543483325', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'15306', N'38279002957')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5d690a66-be1f-4d57-af7d-5557861d2e85', N'Isabel', N'Lozano', CAST(N'2005-09-22' AS Date), N'4191716538', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'44206', N'38151612265')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5d8469c5-011d-46bd-aaad-36ad9de67066', N'Diego', N'Redondo', CAST(N'2008-06-19' AS Date), N'8180526312', N'5526D776-861B-4085-9B5F-91D58221D161', N'19805', N'35279828859')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5d9301e0-395f-4c16-8412-d8b91e9da596', N'Salvador', N'Medina', CAST(N'2012-07-14' AS Date), N'9461657500', N'27C89018-0534-480C-B719-5498EEE22D77', N'75332', N'35809251853')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5da5ffac-ece0-4abf-947f-d6098d50a8ff', N'Isa', N'Caballero', CAST(N'2018-09-12' AS Date), N'9389564076', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'35327', N'31183383638')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5df60fe4-32e9-4bc3-9d09-1383d00d07f5', N'Hugo', N'Rubio', CAST(N'2004-02-17' AS Date), N'1205160113', N'27C89018-0534-480C-B719-5498EEE22D77', N'19783', N'32792902172')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5e12b4de-33a7-428c-98ba-ab80c0bc0bd7', N'Concepción', N'Cabrera', CAST(N'2017-12-14' AS Date), N'4424182618', N'27C89018-0534-480C-B719-5498EEE22D77', N'27987', N'39468664646')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5e1decc8-6ec7-427c-bcf9-4fe28bb3bb5c', N'Juan Carlos', N'Blanco', CAST(N'2016-10-06' AS Date), N'8715533601', N'5526D776-861B-4085-9B5F-91D58221D161', N'88737', N'38976991115')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5e2f5afb-8cc5-4c10-b93a-42c8b2013cfa', N'Lupita', N'Soler', CAST(N'2018-04-14' AS Date), N'2022726729', N'27C89018-0534-480C-B719-5498EEE22D77', N'76346', N'35339451611')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5e56cfdd-330f-4dd7-90c5-2d0e79d2dc23', N'Max', N'Iglesias', CAST(N'2014-05-25' AS Date), N'9722498019', N'5526D776-861B-4085-9B5F-91D58221D161', N'75128', N'30109941176')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5e5c085d-6135-43f9-8430-681cf87f72bc', N'Liliana', N'Moya', CAST(N'2017-06-02' AS Date), N'0393629815', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'44521', N'37030602101')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5e5cf92f-6bf7-4e8b-b5f6-8b89dd112ef9', N'Jaime', N'Pastor', CAST(N'2019-04-19' AS Date), N'5109912843', N'5526D776-861B-4085-9B5F-91D58221D161', N'36538', N'39082625234')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5e63b180-3173-411a-aed6-b254db2f9b61', N'Noe', N'Duran', CAST(N'2001-01-31' AS Date), N'1681345004', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'69111', N'39998327701')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5e75a7b9-08df-4e30-9032-6d90828eaf81', N'Aimon', N'Saez', CAST(N'2016-02-29' AS Date), N'3871692511', N'5526D776-861B-4085-9B5F-91D58221D161', N'06319', N'37897157970')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5e84a1b3-0236-4eec-83bf-c4f473922116', N'Andrés', N'Jimenez', CAST(N'2006-09-14' AS Date), N'9327975033', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'07169', N'38470057185')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5e9fd384-810f-4779-aae9-35f9a7bcfc3c', N'Nacho', N'Gomez', CAST(N'2001-05-27' AS Date), N'6555854735', N'27C89018-0534-480C-B719-5498EEE22D77', N'50864', N'37159821864')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5eaf8522-80b9-4fe9-a4d8-1d604a4862bd', N'Aina', N'Moya', CAST(N'2005-10-25' AS Date), N'4632569513', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'10886', N'38330159376')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5eceb537-7ca7-42ba-b15d-87aacdc6c502', N'Victoria', N'Cano', CAST(N'2014-06-26' AS Date), N'1573885208', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'04096', N'33413657222')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5f425d0a-2fd7-447d-a8f5-74ac124db9d0', N'Ian', N'Hernandez', CAST(N'2019-09-27' AS Date), N'0288976647', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'96308', N'38150917325')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5f93d501-783d-420f-bdbc-4e1a058ba1ae', N'Bronco', N'Name', CAST(N'2009-12-11' AS Date), N'9162501746', N'5526D776-861B-4085-9B5F-91D58221D161', N'71163', N'34336048692')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'5fd9121f-5072-408f-9075-a57fcb771f3e', N'Encarnación', N'Sanz', CAST(N'2008-08-23' AS Date), N'0098963731', N'5526D776-861B-4085-9B5F-91D58221D161', N'72083', N'31094761105')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'602c3c7c-1e2e-472b-b291-ea1475934433', N'Clàudia', N'Andres', CAST(N'2015-02-11' AS Date), N'8869412165', N'5526D776-861B-4085-9B5F-91D58221D161', N'66027', N'33763140778')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'60391128-ff7b-45c3-b67f-bd560b887b5d', N'Fraco', N'Nunez', CAST(N'2011-12-22' AS Date), N'4106972161', N'27C89018-0534-480C-B719-5498EEE22D77', N'57845', N'33501831874')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6049be57-57ca-45c2-99b8-3989cadb161e', N'Daniela', N'Vega', CAST(N'2020-10-08' AS Date), N'3200474655', N'27C89018-0534-480C-B719-5498EEE22D77', N'48034', N'31286143114')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6068c662-230a-4c72-8b7a-3c37f429c3e4', N'Matthew', N'Gonzalez', CAST(N'2020-10-23' AS Date), N'2841168199', N'27C89018-0534-480C-B719-5498EEE22D77', N'59836', N'33202033019')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'606a4b38-383b-44a6-8a19-bad85f9356c6', N'Pepe', N'Moreno', CAST(N'2018-12-10' AS Date), N'1578801079', N'5526D776-861B-4085-9B5F-91D58221D161', N'99450', N'38800093134')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6085ebfc-df16-4f41-99ba-ae8e5a6f3fed', N'Fernando', N'Alonso', CAST(N'2020-12-06' AS Date), N'5619829755', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'31020', N'39331414233')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'60e0b06c-be6e-40dd-813d-091ecce1950a', N'Narcisa', N'Cabrera', CAST(N'2021-01-01' AS Date), N'0896457370', N'27C89018-0534-480C-B719-5498EEE22D77', N'64275', N'34765639397')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'611048f8-1411-476b-acdd-38bc5cf4eadd', N'Rafa', N'Iglesias', CAST(N'2004-04-25' AS Date), N'3572198701', N'5526D776-861B-4085-9B5F-91D58221D161', N'99956', N'32876529744')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'61601916-3eeb-4ba8-a7c3-5b58bcccc6ab', N'Xavion', N'Campos', CAST(N'2012-01-04' AS Date), N'4699322447', N'5526D776-861B-4085-9B5F-91D58221D161', N'00451', N'39186118813')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6170e28c-7742-4626-82ee-87b350b7fc2f', N'Dario', N'Lorenzo', CAST(N'2004-11-20' AS Date), N'9073114511', N'5526D776-861B-4085-9B5F-91D58221D161', N'12704', N'39399538964')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6173cac2-1cb1-45f4-a6a5-e4a8ef2e0cd3', N'Fernando', N'Torres', CAST(N'2013-11-13' AS Date), N'2880139191', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'71356', N'32877919406')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'617a8559-3cfa-4289-bc35-f8312712256d', N'Mateo', N'Lorenzo', CAST(N'2005-11-18' AS Date), N'4660791092', N'27C89018-0534-480C-B719-5498EEE22D77', N'85678', N'30008643278')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'61e76126-4792-48ed-8950-a40e1fbc83b8', N'Rosa', N'Crespo', CAST(N'2003-02-17' AS Date), N'4159057819', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'16958', N'36804010892')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'62051bb1-f8a6-4e6b-a32c-05f757bcbe66', N'Xaverius', N'Alonso', CAST(N'2019-03-16' AS Date), N'8681356576', N'5526D776-861B-4085-9B5F-91D58221D161', N'86189', N'34085013821')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6235983f-27f7-49b2-b604-9b255fd15daf', N'Marcelo', N'Roman', CAST(N'2005-10-28' AS Date), N'4962379666', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'55512', N'32427053582')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6241ce65-35c8-4b6a-bb10-f054a49c2493', N'Montego', N'Pastor', CAST(N'2019-01-16' AS Date), N'8292877834', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'52044', N'37109166121')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'629770b6-fc91-4740-ae08-34e455eaa2c3', N'Antonio', N'Nieto', CAST(N'2021-04-04' AS Date), N'4769925486', N'5526D776-861B-4085-9B5F-91D58221D161', N'98841', N'34749539045')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'62ad1aab-f00f-40bf-ad03-0b96b400a0a5', N'Daniela', N'Morales', CAST(N'2002-06-01' AS Date), N'8144379612', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'59710', N'31472153609')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'62c000a9-c497-46ca-ae6a-9491a3999c74', N'Valentino', N'Moya', CAST(N'2012-03-06' AS Date), N'9664457161', N'27C89018-0534-480C-B719-5498EEE22D77', N'86407', N'30793229337')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'62c180be-7fda-4dc1-9dcb-c29526a72d31', N'Altagracia', N'Cabrera', CAST(N'2017-07-18' AS Date), N'4348790966', N'5526D776-861B-4085-9B5F-91D58221D161', N'72532', N'31238109644')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'62e2ff6b-d4e3-489e-9d6c-4eabd90333ef', N'Virginia', N'Romero', CAST(N'2014-09-24' AS Date), N'4714911644', N'5526D776-861B-4085-9B5F-91D58221D161', N'03733', N'37544608426')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'62e4393d-d494-4b1c-a408-554ae2f6e4bc', N'Jaime', N'Guerrero', CAST(N'2008-02-21' AS Date), N'3939365525', N'27C89018-0534-480C-B719-5498EEE22D77', N'19602', N'37395812872')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'62fb6939-f56f-4c85-b9ee-a249288e0387', N'Bronco', N'Rodriguez', CAST(N'2009-05-01' AS Date), N'3690541299', N'5526D776-861B-4085-9B5F-91D58221D161', N'79233', N'35199569485')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'62fd8708-8a11-4f69-a41f-f9f75979e28d', N'Tomasa', N'Aguilar', CAST(N'2013-07-13' AS Date), N'1948928498', N'5526D776-861B-4085-9B5F-91D58221D161', N'82101', N'31455818634')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'62ff39e9-8913-4331-80f4-ac0171a47405', N'Encarnación', N'Andres', CAST(N'2004-04-25' AS Date), N'8363720280', N'27C89018-0534-480C-B719-5498EEE22D77', N'59734', N'36838058683')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'63002af8-ffdc-449c-a139-c0101811f2d9', N'Pedro', N'Soto', CAST(N'2020-06-17' AS Date), N'8518679829', N'5526D776-861B-4085-9B5F-91D58221D161', N'66475', N'37298737673')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6317ee34-ad7b-495a-bc7a-c11a604b0522', N'Sandra', N'Diaz', CAST(N'2005-08-29' AS Date), N'2040255365', N'5526D776-861B-4085-9B5F-91D58221D161', N'17676', N'33520566179')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6360cd37-16de-4c85-9f7c-e6c1c0a96f50', N'Benjamín', N'Gil', CAST(N'2014-12-03' AS Date), N'3329984974', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'67995', N'39046817402')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'63d96cff-b1e7-48a0-9adb-460d9c09910f', N'Beatriz', N'Duran', CAST(N'2016-06-07' AS Date), N'2068491380', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'75042', N'34438269762')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'64198212-5dd5-485c-9e00-0021ebf903d8', N'Guadalupe', N'Martin', CAST(N'2008-03-06' AS Date), N'4927079019', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'13367', N'38048889010')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'643ce411-8608-40fc-aaa5-4d0ac4afd564', N'Iker', N'Marcos', CAST(N'2017-03-19' AS Date), N'7854709149', N'27C89018-0534-480C-B719-5498EEE22D77', N'45386', N'34616159379')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6440bc98-f524-42e9-93db-1980ffa561df', N'Shizuko', N'Torres', CAST(N'2015-03-24' AS Date), N'4592346227', N'5526D776-861B-4085-9B5F-91D58221D161', N'20547', N'31198369361')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'64573398-25b1-4d28-ba3e-715ac406b135', N'Cándida', N'Bravo', CAST(N'2006-10-17' AS Date), N'9970555534', N'27C89018-0534-480C-B719-5498EEE22D77', N'43448', N'32133609427')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6462f678-c740-44f2-af1f-0bb3ec4e135f', N'Malvolio', N'Alonso', CAST(N'2000-01-26' AS Date), N'1724652573', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'34034', N'30529363608')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'648b7989-e71f-48d9-aaa8-e11a9ccf4daa', N'Blanca', N'Blanco', CAST(N'2001-01-06' AS Date), N'6814480543', N'5526D776-861B-4085-9B5F-91D58221D161', N'53880', N'31668503469')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6495cc50-024f-4513-a830-b73ac2b3f393', N'Helena', N'Castillo', CAST(N'2007-07-19' AS Date), N'9193293564', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'13856', N'39683244791')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'64a8d76d-332e-4e31-a1cd-894aa0ec968c', N'Dimos', N'Garrido', CAST(N'2003-07-07' AS Date), N'3226489089', N'27C89018-0534-480C-B719-5498EEE22D77', N'94115', N'35895879122')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6511b8c3-ebb1-4011-b39d-9a30e62b6bab', N'Rafael', N'Rey', CAST(N'2014-03-19' AS Date), N'1426637731', N'27C89018-0534-480C-B719-5498EEE22D77', N'93361', N'36897784140')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'654c25d1-8e1a-45c6-a432-cff2f806c999', N'Jose manuel', N'Duran', CAST(N'2008-09-10' AS Date), N'4772089450', N'5526D776-861B-4085-9B5F-91D58221D161', N'47856', N'39603952488')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'65b5ab6c-9390-4850-a5c0-d82701303793', N'Manolo', N'Guerrero', CAST(N'2017-03-04' AS Date), N'1556757986', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'63548', N'34185161953')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'65e906f8-ecdd-4cf0-acbe-46ac413b682d', N'Pepe', N'Gil', CAST(N'2008-07-24' AS Date), N'3557121212', N'5526D776-861B-4085-9B5F-91D58221D161', N'65745', N'39510632392')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'66151c77-875c-442d-8d82-04e5c0353312', N'Lourdes', N'Hernandez', CAST(N'2004-10-26' AS Date), N'2442183283', N'27C89018-0534-480C-B719-5498EEE22D77', N'44754', N'38867590848')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'664e5b43-d007-4809-bf54-83c35d1e7ac2', N'Berto', N'Suarez', CAST(N'2007-05-22' AS Date), N'5414546573', N'5526D776-861B-4085-9B5F-91D58221D161', N'32476', N'32606563948')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'664ea28a-e089-4214-8456-c317acc25e94', N'Marcelina', N'Name', CAST(N'2007-08-02' AS Date), N'8118268589', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'39512', N'39007994194')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'665392b1-beb2-417b-902f-d1d3a793bf35', N'Sebastián', N'Gil', CAST(N'2000-03-26' AS Date), N'7927657457', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'85266', N'34258280124')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'665d742f-31b3-4aad-810b-7630bb892364', N'Consolación', N'Roman', CAST(N'2010-04-20' AS Date), N'5202437535', N'27C89018-0534-480C-B719-5498EEE22D77', N'67199', N'31231954065')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'666a06e0-3306-46a8-bc2c-a11f98cad72e', N'Olga', N'Moreno', CAST(N'2009-09-15' AS Date), N'2142058970', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'34731', N'30466903553')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'667b692e-901f-4527-b9b6-4b09c31c0954', N'Karina', N'Hidalgo', CAST(N'2015-12-27' AS Date), N'2612346721', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'61655', N'39328161904')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6690316b-0c6a-4802-941e-011790ad6d7c', N'Guillermo', N'Pastor', CAST(N'2007-02-08' AS Date), N'0771897920', N'27C89018-0534-480C-B719-5498EEE22D77', N'24549', N'32528042455')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'66a3d63d-47c8-429d-966b-5a5b6959c108', N'Carlos', N'Flores', CAST(N'2021-12-09' AS Date), N'1525588927', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'18154', N'35685063236')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'66c37f48-c10b-43f2-894d-ff1132b02cdf', N'Mayte', N'Arias', CAST(N'2011-06-08' AS Date), N'4874045653', N'5526D776-861B-4085-9B5F-91D58221D161', N'52175', N'32893464937')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'66cc1c9c-bb9c-4920-aff3-d7802e9ba0d7', N'Frisco', N'Merino', CAST(N'2006-08-17' AS Date), N'1882145618', N'27C89018-0534-480C-B719-5498EEE22D77', N'05658', N'38632750634')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'66eba04b-62c0-43af-ba80-091d43ccb0e9', N'Facundo', N'Jimenez', CAST(N'2010-09-23' AS Date), N'0609478690', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'67698', N'32779029679')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'66f0f357-c245-4459-889c-997e2af0cf9c', N'Nuria', N'Merino', CAST(N'2013-10-05' AS Date), N'9320998197', N'5526D776-861B-4085-9B5F-91D58221D161', N'26666', N'33907484870')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'670a8286-8629-4f3f-9243-6be73b0f4a4d', N'Malvolio', N'Ibanez', CAST(N'2012-09-09' AS Date), N'6426025465', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'37138', N'37455214595')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'673a5451-2a15-4ce8-98f4-e8aaf0e5d498', N'Gloria', N'Cruz', CAST(N'2017-07-04' AS Date), N'7441672456', N'5526D776-861B-4085-9B5F-91D58221D161', N'42621', N'36071460342')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6777406c-27b0-40d9-b5a1-48e3c514dbd2', N'Paul', N'Romero', CAST(N'2000-02-19' AS Date), N'1957763729', N'5526D776-861B-4085-9B5F-91D58221D161', N'81502', N'34424592821')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'67852f3e-4e4e-46f3-835d-4a289a3ed1ee', N'Montenegro', N'Ruiz', CAST(N'2013-12-02' AS Date), N'4453582823', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'23885', N'35793471896')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6785d488-1a64-40ac-9f55-899f59205497', N'Yesenia', N'Ibanez', CAST(N'2009-05-24' AS Date), N'5611661812', N'27C89018-0534-480C-B719-5498EEE22D77', N'77671', N'33943631739')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'67ab8ad6-aa61-467c-97b8-2017e6d49ee7', N'Marina', N'Soler', CAST(N'2002-11-03' AS Date), N'8378466968', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'14520', N'37913333750')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'67bf6574-c6b8-477d-94bc-036a6b51a666', N'Dimos', N'Redondo', CAST(N'2018-09-16' AS Date), N'5905661990', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'65954', N'36743154701')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'67c1aaea-3b87-44fb-a4eb-4fec3b8cccb9', N'Valentino', N'Romero', CAST(N'2002-07-19' AS Date), N'7737029484', N'5526D776-861B-4085-9B5F-91D58221D161', N'96473', N'36048425215')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'67f33e7d-aa2e-49aa-af47-86df161b7af3', N'Juana', N'Mendez', CAST(N'2019-12-22' AS Date), N'2787776793', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'92238', N'35572839052')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'67fce887-4ced-4a9c-9bd0-18012fcb8194', N'Salvador', N'Dominguez', CAST(N'2017-04-16' AS Date), N'2841856821', N'5526D776-861B-4085-9B5F-91D58221D161', N'60079', N'31340813838')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'68679155-1925-46f3-b109-1fb684bcdb81', N'Dorotea', N'Reyes', CAST(N'2011-01-21' AS Date), N'4595139708', N'27C89018-0534-480C-B719-5498EEE22D77', N'79823', N'34725792250')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6873cb07-7bb4-44e0-976f-f407c6f4c0a8', N'Arnau', N'Campos', CAST(N'2003-12-25' AS Date), N'5177451476', N'5526D776-861B-4085-9B5F-91D58221D161', N'48944', N'39172909761')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6885d08e-ca4e-4c05-bdb1-80617dcbf392', N'Emiliano', N'Nieto', CAST(N'2003-07-10' AS Date), N'7000396317', N'5526D776-861B-4085-9B5F-91D58221D161', N'26717', N'35861645705')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'68b09dae-59d9-4695-b849-2d88dab039e1', N'Felicidad', N'Delgado', CAST(N'2004-04-26' AS Date), N'6389991233', N'27C89018-0534-480C-B719-5498EEE22D77', N'87441', N'31033177600')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'68df4e69-b125-40db-8b8d-a530338a8818', N'Samuel', N'Morales', CAST(N'2018-03-17' AS Date), N'4118863456', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'67633', N'38602930129')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'69944e9d-d6e3-4ac7-a8ff-6adddad8f720', N'Agapetus', N'Delgado', CAST(N'2002-07-06' AS Date), N'9298275690', N'5526D776-861B-4085-9B5F-91D58221D161', N'41768', N'35434298966')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6a29fd8f-1b25-47a5-8f4a-b0fc23502ed8', N'Encarnación', N'Ortega', CAST(N'2005-05-25' AS Date), N'2052450756', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'63604', N'32095007929')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6a75f5c7-b72e-4420-a385-fca6d864f23c', N'Andrés', N'Vicente', CAST(N'2006-02-12' AS Date), N'9961454459', N'27C89018-0534-480C-B719-5498EEE22D77', N'01137', N'32428119706')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6a7d2183-bae1-4768-8eea-ac16d48566e4', N'Victoria', N'Diaz', CAST(N'2003-08-29' AS Date), N'4938833734', N'5526D776-861B-4085-9B5F-91D58221D161', N'61515', N'37045593966')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6a86b872-8c88-4c69-86b2-987753bfea64', N'Nuria', N'Delgado', CAST(N'2014-08-19' AS Date), N'0692957155', N'27C89018-0534-480C-B719-5498EEE22D77', N'52669', N'38905917233')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6a9075dc-f205-4ee0-96e5-806ddac33f05', N'Inés', N'Blanco', CAST(N'2012-05-13' AS Date), N'0948384938', N'27C89018-0534-480C-B719-5498EEE22D77', N'87726', N'39978208442')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6aae6146-db0e-47f4-9cb9-35879b974c31', N'Aimon', N'Marcos', CAST(N'2019-12-01' AS Date), N'5179966704', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'81959', N'30948596540')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6b1117e8-8425-44bc-be16-90b02242d95e', N'Benita', N'Reyes', CAST(N'2004-12-17' AS Date), N'4266550481', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'63073', N'34704570584')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6b39d9ed-f685-45a8-b802-8925d4afeec2', N'Nora', N'Crespo', CAST(N'2010-05-04' AS Date), N'8609761781', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'87294', N'39814691705')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6b4b1f9f-5e2e-48da-bbb2-c387bc119007', N'Enriqueta', N'Molina', CAST(N'2017-09-16' AS Date), N'1841963422', N'5526D776-861B-4085-9B5F-91D58221D161', N'46357', N'31859304057')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6b5e64a1-31af-450a-bdc3-3d4d899c1ac7', N'Jaguar', N'Fernandez', CAST(N'2004-07-30' AS Date), N'5082683822', N'27C89018-0534-480C-B719-5498EEE22D77', N'89955', N'36499033357')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6b6ec915-4068-48bf-96ab-b18f46d342c8', N'Juan Felipe', N'Menendez', CAST(N'2007-03-06' AS Date), N'7379127585', N'27C89018-0534-480C-B719-5498EEE22D77', N'48671', N'33745626188')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6b7e4e23-a09d-43e2-ba4f-7f087b7c4ff2', N'Manolo', N'Sanchez', CAST(N'2007-07-25' AS Date), N'4678269494', N'27C89018-0534-480C-B719-5498EEE22D77', N'64949', N'32979851735')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6bcc56a4-a551-412c-a6f7-29d17ee04ee4', N'Paz', N'Ruiz', CAST(N'2016-06-10' AS Date), N'6782678310', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'07393', N'37445516254')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6bf2fd59-efe2-4f57-8c22-e40495f5796d', N'Juan Pablo', N'Marquez', CAST(N'2018-09-01' AS Date), N'3584839668', N'5526D776-861B-4085-9B5F-91D58221D161', N'65249', N'31731676091')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6c07c062-5dec-41ef-a72d-ff633104c69d', N'Verónica', N'Vazquez', CAST(N'2012-05-10' AS Date), N'2952283817', N'5526D776-861B-4085-9B5F-91D58221D161', N'15379', N'37902301555')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6c1aa1ae-445c-4ffc-a0e2-23d63144a0a2', N'Jose manuel', N'Pena', CAST(N'2006-09-03' AS Date), N'2315167453', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'97640', N'32853207477')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6c4c9083-a778-49d2-98ab-5d1a8aa90026', N'Jaguar', N'Saez', CAST(N'2005-03-03' AS Date), N'3105665838', N'5526D776-861B-4085-9B5F-91D58221D161', N'74002', N'35198687279')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6c58bf46-6c75-48b6-bbf9-e9d6ff6c463d', N'Ariadna', N'Lopez', CAST(N'2018-08-13' AS Date), N'7339790838', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'89577', N'32304408968')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6c5d22d7-13bb-4b9a-81c7-c159ee0feeb5', N'Lía', N'Gomez', CAST(N'2005-07-28' AS Date), N'8910815452', N'5526D776-861B-4085-9B5F-91D58221D161', N'54849', N'30411766519')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6c6b99f0-407c-4751-921d-3fc8ba2278f6', N'Micaela', N'Calvo', CAST(N'2004-12-13' AS Date), N'0566451175', N'5526D776-861B-4085-9B5F-91D58221D161', N'54080', N'34205456395')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6c706333-2079-4704-b0c9-7bfb55859872', N'Ulrica', N'Cortes', CAST(N'2018-06-04' AS Date), N'4192174610', N'5526D776-861B-4085-9B5F-91D58221D161', N'67736', N'32816749066')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6c7066b8-65b2-4647-a6af-cc0f16635e40', N'Zulma', N'Ortega', CAST(N'2012-01-08' AS Date), N'1301809753', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'05090', N'37955498827')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6c96a7a4-6c73-4d45-92e1-9bd540c7ef42', N'Mercedes', N'Mendez', CAST(N'2006-02-03' AS Date), N'3443401933', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'65258', N'32101689756')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6ca6149e-1e95-4ca1-802b-9a5c5e11b104', N'Vidal', N'Prieto', CAST(N'2015-03-05' AS Date), N'5743723768', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'92644', N'35032272311')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6cd91f3a-c71a-47c4-a10f-735c042d57e4', N'Gloria', N'Rubio', CAST(N'2002-08-09' AS Date), N'4006764922', N'27C89018-0534-480C-B719-5498EEE22D77', N'11814', N'38141406440')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6cdf29df-4100-4627-bbef-05d3067deb37', N'Juana', N'Martinez', CAST(N'2007-03-25' AS Date), N'6780180796', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'57175', N'33251539307')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6d9b27f2-eba3-46b0-a75f-7f7f27fa667a', N'Montel', N'Marquez', CAST(N'2012-01-17' AS Date), N'0798648854', N'5526D776-861B-4085-9B5F-91D58221D161', N'28152', N'36779777425')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6dcf88e9-8a42-4c28-8e76-3e77c6461bcb', N'Carito', N'Izquierdo', CAST(N'2004-10-04' AS Date), N'7636030722', N'5526D776-861B-4085-9B5F-91D58221D161', N'03080', N'35850039163')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6dd2e9bb-dceb-4aa7-94af-b55a3a2c0a3f', N'Kiki', N'Arias', CAST(N'2011-02-18' AS Date), N'9092072128', N'5526D776-861B-4085-9B5F-91D58221D161', N'37761', N'38698653571')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6df26169-8276-4eeb-973e-1e96f071c463', N'Julia', N'Saez', CAST(N'2007-10-03' AS Date), N'0527046996', N'27C89018-0534-480C-B719-5498EEE22D77', N'32489', N'32929761637')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6e3291c9-0f1c-4e8a-92b1-3ce30728cd17', N'Concepción', N'Flores', CAST(N'2017-04-27' AS Date), N'6014679722', N'27C89018-0534-480C-B719-5498EEE22D77', N'96082', N'37027215181')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6e6c9607-d8d8-4349-b767-f6986d6ecad0', N'Cristóbal', N'Santos', CAST(N'2021-10-23' AS Date), N'9320824837', N'5526D776-861B-4085-9B5F-91D58221D161', N'67780', N'38842653465')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6e986d41-4050-424f-9639-607b23d20db4', N'Jose miguel', N'Castillo', CAST(N'2013-05-23' AS Date), N'2236102288', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'93095', N'30555494341')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6ea954f3-6da3-4e51-ae11-2b8bf0f7ee8d', N'Max', N'Garcia', CAST(N'2007-07-25' AS Date), N'0287803102', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'50574', N'35074571586')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6eaae453-59f8-4031-b54f-8c0c0aaf5d4a', N'Emma', N'Ibanez', CAST(N'2011-11-06' AS Date), N'5388220231', N'5526D776-861B-4085-9B5F-91D58221D161', N'09028', N'34305344961')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6f09f63d-35ac-43cb-9c56-43536ab9d306', N'Manu', N'Carmona', CAST(N'2013-10-12' AS Date), N'7145130981', N'5526D776-861B-4085-9B5F-91D58221D161', N'33722', N'35833347535')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6f692acd-1dfa-4907-bb45-c7d777c0b1d0', N'dani', N'Rodriguez', CAST(N'2018-01-10' AS Date), N'0986457250', N'5526D776-861B-4085-9B5F-91D58221D161', N'50085', N'37803819680')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'6fc10118-566f-43fd-9738-97633ee9b1a5', N'Soraya', N'Cruz', CAST(N'2019-08-22' AS Date), N'2578105778', N'5526D776-861B-4085-9B5F-91D58221D161', N'26394', N'35042187066')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7016ec1b-2375-4219-9700-d803bcf6451d', N'Raul', N'Carmona', CAST(N'2016-04-22' AS Date), N'4958618767', N'5526D776-861B-4085-9B5F-91D58221D161', N'39648', N'33296223166')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'704cd292-f1be-4b7c-a7f2-7a43adddcdc5', N'Piedad', N'Blanco', CAST(N'2020-04-20' AS Date), N'9761610753', N'27C89018-0534-480C-B719-5498EEE22D77', N'57722', N'36174947541')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'706732a9-7cd9-4940-a30e-1c7a77142dfd', N'Cruz', N'Ruiz', CAST(N'2017-10-12' AS Date), N'6710725247', N'27C89018-0534-480C-B719-5498EEE22D77', N'47181', N'37069097286')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'70b073bb-5cfe-4e81-bff6-7752cf6ca797', N'Andrea', N'Gonzalez', CAST(N'2003-03-10' AS Date), N'6934877568', N'5526D776-861B-4085-9B5F-91D58221D161', N'07963', N'30057951316')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'70b2490f-a41b-42cf-bdfb-36b1718bcacc', N'Juan Ignacio', N'Crespo', CAST(N'2017-05-06' AS Date), N'5552118974', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'88697', N'33272697914')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'70d5b05f-019d-4e43-9b6b-026202c2e102', N'Nasario', N'Fernandez', CAST(N'2017-10-23' AS Date), N'6423621550', N'5526D776-861B-4085-9B5F-91D58221D161', N'51228', N'38907588105')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'70d88f69-7b3c-4243-ad29-2ba40227f983', N'Paulette', N'Aguilar', CAST(N'2014-05-05' AS Date), N'2564462731', N'27C89018-0534-480C-B719-5498EEE22D77', N'59915', N'30600472270')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'70e0e7cb-c9cc-4bdf-ac2b-07a47c2d595e', N'Rodolfa', N'Prieto', CAST(N'2004-05-31' AS Date), N'8593209076', N'27C89018-0534-480C-B719-5498EEE22D77', N'27278', N'38694904264')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'70ef9694-171f-44d4-b9e2-497da257fc43', N'Alan', N'Vega', CAST(N'2013-01-04' AS Date), N'0529083833', N'5526D776-861B-4085-9B5F-91D58221D161', N'45647', N'30228967683')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'70f42559-b903-460e-b76e-6cc6db486f72', N'Anna', N'Dominguez', CAST(N'2004-12-05' AS Date), N'8575191154', N'5526D776-861B-4085-9B5F-91D58221D161', N'88767', N'31149002661')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'710b9e21-8595-489a-9a2b-55bca59fcad5', N'Ariadna', N'Vazquez', CAST(N'2007-05-06' AS Date), N'7572386780', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'33602', N'33331592893')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7117ba4a-896c-4ee3-85d0-dc4bdf09b415', N'Lara', N'Ruiz', CAST(N'2018-11-10' AS Date), N'5600110395', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'36357', N'30483357020')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'71225e4f-17e2-4464-bc94-50e6f50478e0', N'Alberto', N'Alvarez', CAST(N'2001-01-01' AS Date), N'4431189569', N'5526D776-861B-4085-9B5F-91D58221D161', N'63469', N'30222748172')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'716324e5-61c2-4aa8-9d52-1adc32795ae3', N'Elisa', N'Marin', CAST(N'2020-08-18' AS Date), N'5132169809', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'42650', N'35572921371')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'717fdb28-22e0-40fd-9f6e-d485ccae200c', N'Inma', N'Jimenez', CAST(N'2011-02-01' AS Date), N'1281202780', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'87776', N'39703817197')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7191bb13-80bb-4757-bfc4-d38a3f7a2299', N'Itahisa', N'Menendez', CAST(N'2018-01-27' AS Date), N'0610726817', N'27C89018-0534-480C-B719-5498EEE22D77', N'37156', N'37272138680')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'71cbd692-84ea-4dc3-b069-31708888c5a0', N'Martina', N'Redondo', CAST(N'2018-04-06' AS Date), N'7544984289', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'76455', N'31052632379')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'71ce2454-6922-42ff-862f-159a207e2409', N'Maite', N'Ferrer', CAST(N'2014-11-06' AS Date), N'4570073793', N'5526D776-861B-4085-9B5F-91D58221D161', N'76226', N'35141013770')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'720c39b8-88d2-4c92-a0e6-143adae46cce', N'Rosa', N'Vicente', CAST(N'2006-03-05' AS Date), N'6719915429', N'27C89018-0534-480C-B719-5498EEE22D77', N'56621', N'38836537301')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7266ee03-03ac-4e95-990a-179cfa4512a9', N'Itahisa', N'Hidalgo', CAST(N'2010-11-03' AS Date), N'8423755446', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'66145', N'32929470210')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7278b652-b1ce-43e3-9410-13bb01dbf34e', N'Elena', N'Marin', CAST(N'2005-02-16' AS Date), N'3552895294', N'5526D776-861B-4085-9B5F-91D58221D161', N'51201', N'38548156222')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'72b8e65f-3dbc-48d8-8043-e84812eb3e8e', N'Amalia', N'Menendez', CAST(N'2011-12-17' AS Date), N'8434987283', N'5526D776-861B-4085-9B5F-91D58221D161', N'16508', N'30546196536')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7305c9e4-8175-41a9-ba0b-8d1456338393', N'Borja', N'Carrasco', CAST(N'2011-12-11' AS Date), N'4881474103', N'27C89018-0534-480C-B719-5498EEE22D77', N'82934', N'35341221253')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7336bd71-2782-4cbc-a700-d33033c7a45b', N'Sergi', N'Montero', CAST(N'2018-05-23' AS Date), N'4619552688', N'5526D776-861B-4085-9B5F-91D58221D161', N'74627', N'36127524849')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'73384366-0f3b-4d8d-ab7c-7cdfa97e2747', N'Fraco', N'Nieto', CAST(N'2007-09-26' AS Date), N'5046840011', N'27C89018-0534-480C-B719-5498EEE22D77', N'87972', N'30700781706')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'73547a0d-6b21-4080-9544-e0b09085b657', N'Loredo', N'Rodriguez', CAST(N'2002-08-05' AS Date), N'8753418013', N'27C89018-0534-480C-B719-5498EEE22D77', N'39801', N'38829756809')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7358ad16-3ec3-4597-a7d5-a50a282adb4f', N'Ismael', N'Hidalgo', CAST(N'2013-03-18' AS Date), N'8557904041', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'74412', N'36512371423')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'735c4b49-2aaa-418f-bb75-efcaa6f21672', N'Miriam', N'Pena', CAST(N'2002-11-15' AS Date), N'0382244304', N'27C89018-0534-480C-B719-5498EEE22D77', N'77912', N'30942167151')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'73812bd1-119e-48ac-a200-de061e01ebe6', N'Gorka', N'Alonso', CAST(N'2020-11-24' AS Date), N'9283300920', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'45886', N'37249297468')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'73975dda-9fe3-4cac-9424-b37ac08f46a4', N'Paco', N'Garcia', CAST(N'2021-01-10' AS Date), N'3901077423', N'27C89018-0534-480C-B719-5498EEE22D77', N'57102', N'33717224343')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'73aef912-66e4-41d8-a2fb-42320551322b', N'Adelia', N'Marcos', CAST(N'2002-02-12' AS Date), N'9390705006', N'27C89018-0534-480C-B719-5498EEE22D77', N'69145', N'31799617291')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'73b32fa3-1bdc-46cb-920c-19c15d2d27a4', N'Juanma', N'Sanz', CAST(N'2020-07-13' AS Date), N'2531168635', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'17949', N'38009350739')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'73b3e28a-e46c-46f6-8cb1-97bab9b04860', N'Delia', N'Gomez', CAST(N'2007-06-08' AS Date), N'6933776153', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'27315', N'36350791003')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'73b79cf2-1bab-4fcc-9024-ba0fe7c330fa', N'Mirella', N'Dominguez', CAST(N'2000-05-23' AS Date), N'8381202812', N'5526D776-861B-4085-9B5F-91D58221D161', N'91806', N'37677419051')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'73e787cf-26fd-4534-842a-0b8c5f325236', N'Pascuala', N'Pena', CAST(N'2015-10-21' AS Date), N'0350504257', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'57275', N'38897376750')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'73f4b175-0df0-4027-a99e-c00a3e3ddfe3', N'Eufemia', N'Navarro', CAST(N'2016-02-13' AS Date), N'3052073107', N'5526D776-861B-4085-9B5F-91D58221D161', N'69505', N'34449481236')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'73f8edc2-abee-47cf-83ba-6e62d6654f17', N'Joan', N'Gimenez', CAST(N'2000-01-12' AS Date), N'3598520585', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'53444', N'34824766490')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7410acfd-614a-4247-a0a3-77598ffd6b67', N'Fran', N'Romero', CAST(N'2002-09-03' AS Date), N'3209631085', N'27C89018-0534-480C-B719-5498EEE22D77', N'53409', N'34334557854')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'74128499-1ae0-4598-afaa-512463401739', N'Maribel', N'Redondo', CAST(N'2011-04-30' AS Date), N'8116946065', N'5526D776-861B-4085-9B5F-91D58221D161', N'39685', N'31194501214')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7442bb24-f30c-451d-9980-6d0823d71ffe', N'Alberto', N'Mora', CAST(N'2004-01-10' AS Date), N'7809433198', N'27C89018-0534-480C-B719-5498EEE22D77', N'03673', N'34639356775')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'745400ba-6127-41d5-9b98-c0af5eca0727', N'Rosario', N'Aguilar', CAST(N'2019-05-15' AS Date), N'1452829159', N'5526D776-861B-4085-9B5F-91D58221D161', N'65922', N'32577704280')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'74c406e2-cf72-4a27-86be-ff6017f11466', N'Zenon', N'Delgado', CAST(N'2014-03-14' AS Date), N'1798268773', N'5526D776-861B-4085-9B5F-91D58221D161', N'47129', N'36016561012')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'74d19321-ac6c-4bf1-b26d-309cf6a47f6e', N'Cándida', N'Mora', CAST(N'2019-09-12' AS Date), N'3753792480', N'5526D776-861B-4085-9B5F-91D58221D161', N'11269', N'37900577948')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'74d88943-e033-4d58-8b3e-f1778d080509', N'Sergi', N'Carmona', CAST(N'2012-01-11' AS Date), N'7341947503', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'64762', N'31486191057')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'74fb73d5-e3d4-4a46-8dae-8aadd1fb47cc', N'Juan David', N'Bravo', CAST(N'2007-02-07' AS Date), N'1382980835', N'5526D776-861B-4085-9B5F-91D58221D161', N'32792', N'37886842229')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'75000bd5-0ced-44c5-8892-9c112d260aed', N'Javier', N'Ferrer', CAST(N'2015-11-24' AS Date), N'6773518585', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'19517', N'36628712513')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7518f2e0-e007-460c-a39f-8d11de69b952', N'Matías', N'Herrero', CAST(N'2016-03-29' AS Date), N'4567283035', N'5526D776-861B-4085-9B5F-91D58221D161', N'06635', N'36861204648')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7523c07d-67b9-4da3-9ce3-235fc9aff4b6', N'Ainara', N'Cruz', CAST(N'2020-06-12' AS Date), N'6789216735', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'50185', N'38237569391')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'75552a49-dfb8-484b-93ef-0ef12eb8e7ab', N'Jimena', N'Redondo', CAST(N'2020-01-23' AS Date), N'4915564729', N'5526D776-861B-4085-9B5F-91D58221D161', N'78799', N'31973602696')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'755c260c-883a-46a4-b2c8-7e7f385423aa', N'martin', N'Soler', CAST(N'2003-08-18' AS Date), N'2520703669', N'5526D776-861B-4085-9B5F-91D58221D161', N'55611', N'32806785995')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7560dc49-51c2-4066-816d-a37f4c9a0be6', N'Carmen', N'Navarro', CAST(N'2021-06-10' AS Date), N'0247550829', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'94029', N'33928530627')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'75670204-67f9-48e2-97d9-ae3031b9f07e', N'Serafina', N'Flores', CAST(N'2014-01-22' AS Date), N'3000160555', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'29436', N'35505545476')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'75c090da-34f7-4128-8bf3-2b01e1779c64', N'Kaori', N'Pena', CAST(N'2009-11-04' AS Date), N'6651982527', N'5526D776-861B-4085-9B5F-91D58221D161', N'94675', N'38402675138')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'764730b3-ce9c-46f1-a859-4f352d1aa22f', N'Jacqueline', N'Blanco', CAST(N'2000-08-08' AS Date), N'8209075893', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'15087', N'30028269060')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'766151fc-e1a5-463f-b388-43cb0d312da9', N'Guido', N'Velasco', CAST(N'2013-11-22' AS Date), N'7697790517', N'5526D776-861B-4085-9B5F-91D58221D161', N'47170', N'37479978831')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'76b6e5d8-85ad-479d-9e75-c2011aad1aa1', N'Carlos', N'Castro', CAST(N'2003-02-22' AS Date), N'6719188533', N'5526D776-861B-4085-9B5F-91D58221D161', N'30926', N'32682246857')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7724b849-afc6-49fd-baed-6704dde16ca2', N'Juan Diego', N'Sanz', CAST(N'2000-07-02' AS Date), N'9746345674', N'27C89018-0534-480C-B719-5498EEE22D77', N'48481', N'36440274184')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'77307ee6-7eb3-4155-939d-6d65431d4227', N'Isaac', N'Rubio', CAST(N'2021-11-23' AS Date), N'8262846272', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'39256', N'39738658192')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'774e586d-b92b-441f-9174-9726b2e638d6', N'Dimos', N'Ibanez', CAST(N'2005-03-08' AS Date), N'1556290792', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'83597', N'33297364995')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'775c8674-6280-4034-8f50-a14415bd74a5', N'Sebastián', N'Vidal', CAST(N'2002-07-30' AS Date), N'4999635796', N'5526D776-861B-4085-9B5F-91D58221D161', N'73289', N'35386213856')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'77748569-fc18-4f62-b349-44cd0762c598', N'Javiera', N'Vega', CAST(N'2015-12-11' AS Date), N'6238638395', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'63484', N'38870967864')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'777a3c34-6000-40cf-8bcb-7641ac1e02db', N'Gretel', N'Gimenez', CAST(N'2003-02-05' AS Date), N'8120252924', N'27C89018-0534-480C-B719-5498EEE22D77', N'09345', N'32177575817')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'77aa5b41-ebcd-4adf-a9e7-db8be105c6ca', N'Miguel Ángel', N'Ferrer', CAST(N'2020-12-29' AS Date), N'2275980360', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'33999', N'37189686790')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'77ba9495-3974-42f2-b40c-cca569561ee0', N'Álvara', N'Navarro', CAST(N'2007-07-03' AS Date), N'1385000275', N'27C89018-0534-480C-B719-5498EEE22D77', N'78444', N'37260850816')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'77e1cc69-edba-4081-aaf4-0587efe11d8e', N'Esperanza', N'Hernandez', CAST(N'2012-08-24' AS Date), N'5721042832', N'27C89018-0534-480C-B719-5498EEE22D77', N'43237', N'37726276516')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'77feace2-d01d-470a-8fad-de8a8b4dfaf5', N'Jerrold', N'Moreno', CAST(N'2004-05-06' AS Date), N'3579100568', N'27C89018-0534-480C-B719-5498EEE22D77', N'87392', N'39101132622')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'781a98a9-1843-4e54-acdb-c924fb4b17d5', N'Imelda', N'Marquez', CAST(N'2006-09-20' AS Date), N'8542334385', N'27C89018-0534-480C-B719-5498EEE22D77', N'28741', N'38501450758')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7837f1a0-ef95-4d2e-b78c-f93962ea8c6e', N'Dayana', N'Merino', CAST(N'2014-03-09' AS Date), N'4311138322', N'5526D776-861B-4085-9B5F-91D58221D161', N'58551', N'30506770083')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'78bc8da3-5c0c-4a8b-86ef-d4686afa3660', N'Sara', N'Navarro', CAST(N'2014-08-15' AS Date), N'9853857544', N'5526D776-861B-4085-9B5F-91D58221D161', N'92064', N'38219251580')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'78c25864-d8fa-41e9-a647-c138c30628b0', N'Valentino', N'Reyes', CAST(N'2001-09-17' AS Date), N'8494307649', N'27C89018-0534-480C-B719-5498EEE22D77', N'56971', N'32553930259')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'78dd3dbe-d7f0-45a1-b9ad-a9a911a238a1', N'Modesta', N'Rodriguez', CAST(N'2000-08-13' AS Date), N'2196870308', N'27C89018-0534-480C-B719-5498EEE22D77', N'67834', N'33102159885')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'78ec8a11-3f84-4361-9d36-1c334a346dba', N'Lolita', N'Pena', CAST(N'2000-06-17' AS Date), N'2466026420', N'27C89018-0534-480C-B719-5498EEE22D77', N'67939', N'32406170618')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'791cf6b6-c0ff-4ba1-a0df-ba3ad792c9af', N'Neron', N'Nieto', CAST(N'2000-10-11' AS Date), N'3591519792', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'64245', N'31470192671')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'79391d6a-5fe9-4702-9488-ff6f4a58670c', N'Meagens', N'Molina', CAST(N'2021-06-06' AS Date), N'8270883426', N'27C89018-0534-480C-B719-5498EEE22D77', N'60704', N'39376001879')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'79620152-fd43-4e04-9e65-2f7b9351ce51', N'Juan Carlos', N'Ruiz', CAST(N'2013-10-24' AS Date), N'0348555433', N'5526D776-861B-4085-9B5F-91D58221D161', N'93564', N'36502789698')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7968a53d-c0b3-48d1-8ae7-31cb7f700d6d', N'Amparo', N'Leon', CAST(N'2015-12-03' AS Date), N'4748429946', N'27C89018-0534-480C-B719-5498EEE22D77', N'74158', N'32053879548')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'796bbce3-4aab-46ca-98af-da32e8665086', N'Aimon', N'Hernandez', CAST(N'2009-01-06' AS Date), N'1752968429', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'56134', N'38819478713')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7998e4a8-d179-4af5-97b4-1ea20750abd8', N'Dante', N'Delgado', CAST(N'2007-01-07' AS Date), N'6789560972', N'27C89018-0534-480C-B719-5498EEE22D77', N'00167', N'36158936794')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'79ff6fe0-8582-4e17-bb58-e12827352683', N'Eva', N'Ramirez', CAST(N'2008-08-09' AS Date), N'9373875293', N'5526D776-861B-4085-9B5F-91D58221D161', N'83938', N'30569483170')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7a28a38c-49c9-4b00-9014-9008eda95d6d', N'Lolita', N'Santos', CAST(N'2001-07-11' AS Date), N'9288236027', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'75273', N'38931833157')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7a79b204-bb62-4831-a73a-b961858d177b', N'Frisco', N'Vicente', CAST(N'2010-12-31' AS Date), N'7382395173', N'5526D776-861B-4085-9B5F-91D58221D161', N'14162', N'35878244472')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7abad218-073c-4876-a655-c08a4748038f', N'Neron', N'Velasco', CAST(N'2007-12-11' AS Date), N'8735810367', N'27C89018-0534-480C-B719-5498EEE22D77', N'85009', N'36027346816')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7ad9dd81-6525-4ea3-aca6-69cdec2285b5', N'Benjamín', N'Duran', CAST(N'2019-07-13' AS Date), N'5651986033', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'53277', N'33736763739')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7aeb32a9-88d8-4f61-ac14-886a6303769e', N'Alejandra', N'Roman', CAST(N'2009-03-06' AS Date), N'7409225066', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'53987', N'37532752497')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7b2da7f8-4b40-4775-8976-c73ccd88b5c0', N'Almudena', N'Name', CAST(N'2015-07-07' AS Date), N'8282872978', N'27C89018-0534-480C-B719-5498EEE22D77', N'97940', N'33718497073')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7b72127e-e189-43ff-b0f4-ad3070c70623', N'Fulca', N'Gonzalez', CAST(N'2007-04-12' AS Date), N'4466569508', N'5526D776-861B-4085-9B5F-91D58221D161', N'53084', N'34515922154')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7b76af10-0211-48fe-abb4-2d8d63305db3', N'Juanita', N'Izquierdo', CAST(N'2007-06-13' AS Date), N'2782613976', N'27C89018-0534-480C-B719-5498EEE22D77', N'39696', N'35503615291')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7b8c6282-8335-4924-92ad-459863fc0d33', N'Angel', N'Suarez', CAST(N'2010-09-05' AS Date), N'6092116555', N'5526D776-861B-4085-9B5F-91D58221D161', N'11481', N'32611423245')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7b8ca57f-d8e2-4fae-9d67-6860e4f4ad24', N'Clotilde', N'Vega', CAST(N'2006-01-14' AS Date), N'6787583864', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'35882', N'38554161653')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7b91c214-330d-426e-a60e-436d82895da6', N'Aarón', N'Izquierdo', CAST(N'2008-04-04' AS Date), N'0376065607', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'55069', N'30547074615')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7bc1cf65-434c-4625-9aab-ad90808d804d', N'Trinidad', N'Fernandez', CAST(N'2016-07-29' AS Date), N'5143842264', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'38541', N'33257773589')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7bd8eb0b-c464-4fd8-ab7e-d13e913d9c0d', N'Pablo', N'Ramos', CAST(N'2009-07-17' AS Date), N'1223814604', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'88716', N'34217406866')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7c549e39-926b-45fe-8ce6-93e398bf9e0e', N'Martita', N'Iglesias', CAST(N'2002-08-11' AS Date), N'0397734449', N'27C89018-0534-480C-B719-5498EEE22D77', N'50621', N'39605827538')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7c63353b-af72-45c8-b828-778381a47d25', N'Flavia', N'Pardo', CAST(N'2011-01-20' AS Date), N'8117544178', N'27C89018-0534-480C-B719-5498EEE22D77', N'83451', N'34252121961')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7c6646f5-061a-41e2-98e1-9872e9e9953e', N'Ababa', N'Campos', CAST(N'2003-09-19' AS Date), N'2727402792', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'34906', N'32210968471')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7cd0d129-a128-454c-b01b-5cb619305d68', N'Hernan', N'Aguilar', CAST(N'2015-10-19' AS Date), N'7276638844', N'27C89018-0534-480C-B719-5498EEE22D77', N'81623', N'35816681545')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7cfe3b73-faba-45c3-b27e-6fb7d64ba1b1', N'Santiago', N'Marin', CAST(N'2003-01-10' AS Date), N'2462805189', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'77013', N'39338178956')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7cffd4e8-1ac6-47fa-a2c7-f4930d20a11c', N'Maribel', N'Pastor', CAST(N'2018-09-02' AS Date), N'4597959642', N'5526D776-861B-4085-9B5F-91D58221D161', N'01373', N'32807091975')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7d0bdafa-2c03-40e9-99c6-f21b1a00916d', N'Fanuco', N'Morales', CAST(N'2002-05-27' AS Date), N'7518372921', N'27C89018-0534-480C-B719-5498EEE22D77', N'60327', N'38244702082')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7d224953-d221-46ed-84cf-f654d7a8b524', N'Aurelia', N'Andres', CAST(N'2009-05-29' AS Date), N'8299669549', N'5526D776-861B-4085-9B5F-91D58221D161', N'62474', N'31214609171')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7d76cba6-95b8-46d2-9a4f-734f0f917cd5', N'África', N'Serrano', CAST(N'2021-06-30' AS Date), N'7108278365', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'72955', N'34536915857')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7da0b61d-718f-484e-a1a8-fcef06d2a36b', N'Dario', N'Alvarez', CAST(N'2011-07-25' AS Date), N'9849089537', N'5526D776-861B-4085-9B5F-91D58221D161', N'61891', N'33616645161')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7db860b7-8d72-4342-93a3-a6861d75b666', N'Diego Alejandro', N'Andres', CAST(N'2020-05-13' AS Date), N'1026990417', N'27C89018-0534-480C-B719-5498EEE22D77', N'90999', N'32404675811')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7df0d9d6-7579-4c9d-926f-26e1a4accd6d', N'Dante', N'Carmona', CAST(N'2017-07-27' AS Date), N'2263067713', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'73266', N'30064614409')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7e33b10c-7e24-42a1-8f0b-e03b7997231d', N'Lorena', N'Gonzalez', CAST(N'2009-11-14' AS Date), N'5177960388', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'99829', N'35639226281')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7e5e9783-5125-49d3-b8ba-5af5c435ed34', N'Santi', N'Herrero', CAST(N'2010-01-17' AS Date), N'9053643284', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'88747', N'31586774039')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7edfd181-1d0f-4ae7-ae04-791ccfd725e9', N'Gael', N'Lozano', CAST(N'2009-11-10' AS Date), N'4653075004', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'36301', N'36501864149')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7efc14f9-b88d-4b85-a0dd-348d3022b35e', N'Ángel', N'Lopez', CAST(N'2009-04-12' AS Date), N'5287978309', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'22839', N'35748805938')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7efef0cc-4e43-4b50-8219-f44f90ab60b5', N'Manuelita', N'Munoz', CAST(N'2013-08-08' AS Date), N'8649887638', N'27C89018-0534-480C-B719-5498EEE22D77', N'57291', N'36231357011')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7f4ea76d-bd47-4bed-93d2-71aee6ee2a86', N'Miguel Ángel', N'Ramirez', CAST(N'2018-11-10' AS Date), N'7115363729', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'20061', N'37078366690')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7f540513-3d60-4fa9-b786-212589de4221', N'Guido', N'Lopez', CAST(N'2013-01-14' AS Date), N'9890083949', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'99017', N'36364538588')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7f644454-f554-4ccf-b222-4f6d32fb55e8', N'Bea', N'Torres', CAST(N'2002-07-26' AS Date), N'7503025589', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'91789', N'38970053836')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7f736b7f-78e8-49b8-b606-7e29339b7a07', N'Juan Esteban', N'Delgado', CAST(N'2019-03-14' AS Date), N'4338760746', N'5526D776-861B-4085-9B5F-91D58221D161', N'43566', N'35464683265')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7f79359d-4070-4ca2-bdad-1a48591d9603', N'Juan Ignacio', N'Saez', CAST(N'2021-07-29' AS Date), N'5537687490', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'88901', N'39566876499')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'7f7b1067-178b-4dc3-9ca6-5bcbb271ecc3', N'Emmanuel', N'Mendez', CAST(N'2017-04-02' AS Date), N'0964013695', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'70306', N'32880102424')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'80155489-aa39-4509-a09b-5bc1b2b495fb', N'Anabel', N'Merino', CAST(N'2018-10-23' AS Date), N'1288839597', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'76031', N'32228595814')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8059b126-f202-4307-bc04-16192e160a66', N'Beltran', N'Herrera', CAST(N'2012-11-26' AS Date), N'5870879759', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'17792', N'39978120122')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'806fc155-b27e-4b52-b2ae-686ad435ab7d', N'Arnau', N'Torres', CAST(N'2001-06-29' AS Date), N'1346645369', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'02368', N'36387539372')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8075c100-50b2-4f11-9a8b-9508db0d2bda', N'Filomena', N'Saez', CAST(N'2007-01-11' AS Date), N'7153633884', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'38749', N'39660990479')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'809fe73e-35fe-4916-a547-9e79999af1db', N'Karina', N'Soler', CAST(N'2009-02-25' AS Date), N'2625807264', N'27C89018-0534-480C-B719-5498EEE22D77', N'15731', N'35869888425')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'80c584b5-ec39-4952-b608-959cb30ecba3', N'Paco', N'Leon', CAST(N'2006-03-15' AS Date), N'2467478136', N'27C89018-0534-480C-B719-5498EEE22D77', N'27900', N'30775307299')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'80f03db5-dd53-4096-ba4e-c4bb6cd39e08', N'Diego Alejandro', N'Izquierdo', CAST(N'2002-12-02' AS Date), N'4503211267', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'80465', N'35773513151')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'810fa262-92fd-46ec-a6fd-7d84e0a47bbb', N'Juan Carlos', N'Duran', CAST(N'2020-03-06' AS Date), N'7868034227', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'26768', N'35970766196')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8115b73f-b828-4b38-acd0-f30330dd2627', N'Citlali', N'Aguilar', CAST(N'2016-07-27' AS Date), N'5517980031', N'5526D776-861B-4085-9B5F-91D58221D161', N'61263', N'35528957736')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8122ee10-19db-4900-80c6-6d77b3ac7cd1', N'Tomasa', N'Morales', CAST(N'2012-08-17' AS Date), N'7671964551', N'27C89018-0534-480C-B719-5498EEE22D77', N'41110', N'35287930157')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'814f2316-7b71-4dd5-ae81-3e425de55855', N'Estela', N'Garcia', CAST(N'2012-07-19' AS Date), N'0292753107', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'20477', N'35465135708')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8151c787-3462-4f41-8abe-18ce1e21b36a', N'Ismael', N'Redondo', CAST(N'2013-11-15' AS Date), N'3991914481', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'46925', N'35054142288')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8161f6dd-e914-4f23-8688-41bafb6be946', N'Patricio', N'Munoz', CAST(N'2012-12-18' AS Date), N'3093088628', N'27C89018-0534-480C-B719-5498EEE22D77', N'53108', N'37769218642')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8180ba6e-02b5-41f8-ab5b-66c3958899f3', N'Toni', N'Navarro', CAST(N'2017-12-01' AS Date), N'4210654463', N'27C89018-0534-480C-B719-5498EEE22D77', N'88874', N'31725073180')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'81cf250a-6daa-4934-ae75-6d4b3188ffe4', N'Rafael', N'Ferrer', CAST(N'2003-07-29' AS Date), N'5541110755', N'27C89018-0534-480C-B719-5498EEE22D77', N'47749', N'32618578733')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'81daf5bb-78d5-4414-8bd9-1315eceb7fe8', N'Juan Pablo', N'Blanco', CAST(N'2000-12-27' AS Date), N'6527581016', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'05125', N'36338084345')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'81fc31f4-d504-4b9c-a0eb-b9075e557a81', N'Albert', N'Jimenez', CAST(N'2005-01-04' AS Date), N'9506008420', N'27C89018-0534-480C-B719-5498EEE22D77', N'59785', N'37809670389')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'81ffe735-e4d7-483b-a196-bb80fb657c2f', N'Alma', N'Perez', CAST(N'2013-08-06' AS Date), N'4375664241', N'27C89018-0534-480C-B719-5498EEE22D77', N'19913', N'30792916920')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'82179df8-310a-4add-815b-57facfcc64d3', N'Ángeles', N'Gil', CAST(N'2012-11-03' AS Date), N'7096439534', N'27C89018-0534-480C-B719-5498EEE22D77', N'87354', N'37225424607')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8246853a-752d-4f75-82fc-89b9e623f109', N'Lucas', N'Ruiz', CAST(N'2006-06-08' AS Date), N'1296419756', N'27C89018-0534-480C-B719-5498EEE22D77', N'51765', N'31845907711')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8283e548-3dd0-4a1e-b0b9-9f75ff81e522', N'Eduardo', N'Molina', CAST(N'2009-02-13' AS Date), N'6828460662', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'63903', N'37976274112')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'82931d79-5d74-4820-97d4-9de6a4fa1d69', N'Luciano', N'Name', CAST(N'2003-01-23' AS Date), N'9066044827', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'06959', N'34765334387')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'829ff6fb-34ed-4e09-acfa-5b21df36c0e7', N'Franco', N'Rubio', CAST(N'2004-12-19' AS Date), N'0970051343', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'62927', N'33390688310')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'82bc3a78-79c4-497f-b56b-3e44bf59dcf9', N'Rosa', N'Garcia', CAST(N'2003-02-09' AS Date), N'6639620412', N'27C89018-0534-480C-B719-5498EEE22D77', N'56421', N'30010751935')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'82c05e42-24df-44b5-b036-859709017848', N'Julia', N'Name', CAST(N'2001-12-25' AS Date), N'2050891645', N'27C89018-0534-480C-B719-5498EEE22D77', N'19058', N'38463593567')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'83008eb1-b1ba-4dac-8029-7a9f0b1530cc', N'Gabriela', N'Molina', CAST(N'2008-03-31' AS Date), N'0448595006', N'27C89018-0534-480C-B719-5498EEE22D77', N'32109', N'33653587911')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8314c2ba-928f-4a81-801a-a214ad23ecec', N'Gabriel', N'Ibanez', CAST(N'2006-03-01' AS Date), N'2800054335', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'59953', N'39701390820')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'83360db6-7137-4155-bb2a-8fcdcf9bb623', N'Gonzalo', N'Vicente', CAST(N'2020-07-18' AS Date), N'4998116960', N'5526D776-861B-4085-9B5F-91D58221D161', N'43337', N'37235072897')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8368fd7c-1a73-436a-af0b-95ffa63d56de', N'Federico', N'Perez', CAST(N'2002-12-06' AS Date), N'0697541941', N'5526D776-861B-4085-9B5F-91D58221D161', N'70069', N'37051289558')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'836e9a82-da3b-4050-a350-6f7bd3e9176a', N'Montenegro', N'Flores', CAST(N'2016-12-22' AS Date), N'1233015716', N'5526D776-861B-4085-9B5F-91D58221D161', N'09691', N'35856363390')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'839aa97b-224b-456a-9c58-4c68b68ac25e', N'Floria', N'Nieto', CAST(N'2001-06-26' AS Date), N'4172585327', N'27C89018-0534-480C-B719-5498EEE22D77', N'74996', N'36444353324')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'83a4c390-161c-45d0-8ccc-f8ff2c1e1d86', N'Dalila', N'Gomez', CAST(N'2015-08-15' AS Date), N'2343160074', N'5526D776-861B-4085-9B5F-91D58221D161', N'13892', N'31998657889')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'83feea47-17af-4ea1-8928-d815b7a2b945', N'Milagros', N'Ramirez', CAST(N'2000-08-27' AS Date), N'6861432277', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'63704', N'39184518179')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8417ebec-07ef-48a8-9f4f-ce3d53a67f6d', N'Jose luis', N'Castro', CAST(N'2009-06-19' AS Date), N'7843496357', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'44788', N'35226643963')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'84343f20-415f-479a-868f-f71af3c2098e', N'Macario', N'Rey', CAST(N'2014-08-31' AS Date), N'5218607254', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'92322', N'32899367319')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'844d543f-ec1c-40e6-bf1b-811536c526b1', N'Juan David', N'Pastor', CAST(N'2004-02-19' AS Date), N'6810517759', N'27C89018-0534-480C-B719-5498EEE22D77', N'84166', N'31614314897')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'84752c6b-2acd-4925-9866-d92c0fcfb65d', N'Jacqueline', N'Redondo', CAST(N'2015-09-13' AS Date), N'0645192742', N'5526D776-861B-4085-9B5F-91D58221D161', N'41735', N'32788011549')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8495ff4c-35dd-4c6d-9b9d-a67e7f5c54c6', N'Jerrold', N'Redondo', CAST(N'2016-06-24' AS Date), N'0187961466', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'49292', N'31988616571')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8499d05c-390e-40a4-b183-46d22eaba8a1', N'Juan Carlos', N'Herrero', CAST(N'2017-03-20' AS Date), N'3444377623', N'5526D776-861B-4085-9B5F-91D58221D161', N'11392', N'33097657763')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'84ba2452-0220-4d64-b142-77cf22c32274', N'Simón', N'Gonzalez', CAST(N'2012-08-24' AS Date), N'2347479474', N'5526D776-861B-4085-9B5F-91D58221D161', N'02664', N'39262248702')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'84c03d67-6200-413a-9f0c-05c5d06f4ee4', N'Vanesa', N'Alonso', CAST(N'2012-06-12' AS Date), N'7587668311', N'27C89018-0534-480C-B719-5498EEE22D77', N'62376', N'39989795786')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'84cce9f3-ab1f-4027-bba5-c614a4ff5142', N'Adelia', N'Reyes', CAST(N'2000-12-08' AS Date), N'6594290537', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'56391', N'32901609822')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'85053a5d-aa4c-40b1-8e58-4f149d307feb', N'adrian', N'Munoz', CAST(N'2007-07-09' AS Date), N'8423468470', N'5526D776-861B-4085-9B5F-91D58221D161', N'91761', N'35473480580')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'85606846-7de9-4b40-854e-51706017f859', N'Hilda', N'Castro', CAST(N'2013-12-23' AS Date), N'3804864399', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'66932', N'35899770970')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'856e3f7c-454c-42e3-975e-d7308e304920', N'Neron', N'Cruz', CAST(N'2020-02-28' AS Date), N'2780553592', N'27C89018-0534-480C-B719-5498EEE22D77', N'25931', N'39819579903')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'859a71ab-ac7b-4a36-9f98-b791e4025ec4', N'Laia', N'Mora', CAST(N'2019-12-29' AS Date), N'0451097235', N'27C89018-0534-480C-B719-5498EEE22D77', N'04598', N'35156290131')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'859fadef-19fc-4977-bc6f-8888fa419d49', N'Adela', N'Hernandez', CAST(N'2004-06-20' AS Date), N'8230777603', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'97325', N'38396702972')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'85c0f0cd-20e0-4928-a15c-03be1071205c', N'Juan Felipe', N'Marquez', CAST(N'2018-11-27' AS Date), N'9009315538', N'5526D776-861B-4085-9B5F-91D58221D161', N'07237', N'38975316249')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8630fbb7-3405-4475-9fae-e83ad27080e2', N'Clotilde', N'Prieto', CAST(N'2009-01-24' AS Date), N'3941062609', N'27C89018-0534-480C-B719-5498EEE22D77', N'84038', N'38529119787')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'86551d75-db08-498b-bbc2-f030d68616f2', N'Natividad', N'Cruz', CAST(N'2001-12-10' AS Date), N'6385883495', N'27C89018-0534-480C-B719-5498EEE22D77', N'15076', N'35019306395')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'866ff581-5c84-4d98-8659-24e08e44d54e', N'Josefa', N'Name', CAST(N'2005-09-26' AS Date), N'4712149122', N'27C89018-0534-480C-B719-5498EEE22D77', N'49637', N'34884809746')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8689878a-f3b4-43b3-9a98-f210b886494e', N'Axel', N'Morales', CAST(N'2003-04-23' AS Date), N'1082750745', N'27C89018-0534-480C-B719-5498EEE22D77', N'27652', N'37473582322')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'86ae55da-7717-4635-81ca-c4818dd933aa', N'Alicia', N'Ortiz', CAST(N'2004-11-17' AS Date), N'2145712652', N'5526D776-861B-4085-9B5F-91D58221D161', N'13073', N'31207081726')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'86ba0511-2998-4595-94e6-f22a9df6e6a9', N'Lali', N'Suarez', CAST(N'2018-10-14' AS Date), N'9545768631', N'5526D776-861B-4085-9B5F-91D58221D161', N'86856', N'38879255960')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'86bb6a20-f792-4555-9bf3-5933656c4d35', N'Citlali', N'Arias', CAST(N'2020-08-03' AS Date), N'2587006580', N'27C89018-0534-480C-B719-5498EEE22D77', N'82037', N'30608115687')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8722cfaf-7c36-4ffc-ba7c-802ba68e3db4', N'Gonzalo', N'Iglesias', CAST(N'2002-06-25' AS Date), N'9618454921', N'5526D776-861B-4085-9B5F-91D58221D161', N'98424', N'36757405294')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'87749a46-abb8-4868-a26b-65c71faff08a', N'Xeres', N'Pastor', CAST(N'2009-06-12' AS Date), N'2886458749', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'24661', N'39687271875')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'87902bf3-ae14-4e88-96bf-f9c65b487793', N'Jose manuel', N'Jimenez', CAST(N'2010-06-14' AS Date), N'7394732965', N'5526D776-861B-4085-9B5F-91D58221D161', N'42773', N'39374306150')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'87b6c7ea-f552-4e10-88b2-18ca89b132c6', N'Sergio', N'Gomez', CAST(N'2008-09-26' AS Date), N'7153218174', N'5526D776-861B-4085-9B5F-91D58221D161', N'45488', N'31542486247')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'87e2d043-550a-4055-8071-d1e181147ffa', N'Dorotea', N'Nieto', CAST(N'2010-02-13' AS Date), N'7737052325', N'27C89018-0534-480C-B719-5498EEE22D77', N'84724', N'36669720862')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'87f66934-d54f-49ce-a2f2-f5cd03992a30', N'Jon', N'Aguilar', CAST(N'2010-06-26' AS Date), N'2960132985', N'27C89018-0534-480C-B719-5498EEE22D77', N'14392', N'34128148983')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'88128497-2443-4780-b0cd-7c79d3194411', N'Álvaro', N'Flores', CAST(N'2021-12-10' AS Date), N'2062437734', N'5526D776-861B-4085-9B5F-91D58221D161', N'78304', N'37501170195')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'88365b81-b3d7-4444-b2f9-83f71d244109', N'Lupita', N'Guerrero', CAST(N'2002-08-20' AS Date), N'3289618423', N'5526D776-861B-4085-9B5F-91D58221D161', N'84533', N'32629800844')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'883d158c-cfe1-43a7-a339-8dd2db960793', N'Mauricio', N'Blanco', CAST(N'2011-02-27' AS Date), N'9427691858', N'27C89018-0534-480C-B719-5498EEE22D77', N'88559', N'35851402357')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8842e042-b497-4c0c-9304-4d958621a9ce', N'Alex', N'Ferrer', CAST(N'2021-06-12' AS Date), N'2950834276', N'5526D776-861B-4085-9B5F-91D58221D161', N'54252', N'37027236940')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'889f4c40-623c-45cb-8bbc-36bf28e9b0dd', N'Tamara', N'Rodriguez', CAST(N'2010-03-30' AS Date), N'6953977731', N'27C89018-0534-480C-B719-5498EEE22D77', N'75723', N'36347574248')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'88a930e6-4c6a-4d46-8db7-2cdd98f34e36', N'Zulma', N'Santos', CAST(N'2004-03-19' AS Date), N'4246921341', N'27C89018-0534-480C-B719-5498EEE22D77', N'96983', N'39215922467')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'88fa7a21-6bdd-4f88-9e12-a55ade577580', N'Victoria', N'Ortiz', CAST(N'2012-04-16' AS Date), N'8298130466', N'5526D776-861B-4085-9B5F-91D58221D161', N'98797', N'32570707887')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8933eb39-c2bf-43a2-ab2d-1e1596a596b3', N'Diego Alejandro', N'Ferrer', CAST(N'2018-11-12' AS Date), N'5260535359', N'27C89018-0534-480C-B719-5498EEE22D77', N'77285', N'36149938216')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'89b7aa61-f975-43d8-95df-0e87bd6e4982', N'Esteban', N'Saez', CAST(N'2008-02-29' AS Date), N'0227889332', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'46354', N'33217886317')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'89c3a978-7806-4847-9004-e440347902de', N'Xaver', N'Aguilar', CAST(N'2009-06-24' AS Date), N'0527391553', N'5526D776-861B-4085-9B5F-91D58221D161', N'49759', N'31646909609')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'89d3df3d-e08d-4a04-be05-275a9f1bfbe5', N'Asier', N'Castillo', CAST(N'2010-11-22' AS Date), N'8308028425', N'27C89018-0534-480C-B719-5498EEE22D77', N'35066', N'31857498267')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8a97ad6b-586e-4e84-8cec-b1166eafa0ed', N'Caleb', N'Cruz', CAST(N'2009-11-15' AS Date), N'5951034206', N'5526D776-861B-4085-9B5F-91D58221D161', N'51558', N'37767258141')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8ab5c977-d11a-466c-ac33-430db6f47ae0', N'Leticia', N'Moya', CAST(N'2002-01-12' AS Date), N'7254883032', N'27C89018-0534-480C-B719-5498EEE22D77', N'05724', N'31630647828')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8abfae59-f09a-47fd-adb3-76c145799e4e', N'Adela', N'Vicente', CAST(N'2021-03-24' AS Date), N'0295692825', N'27C89018-0534-480C-B719-5498EEE22D77', N'07273', N'38405533029')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8ac1774d-ca72-4cf9-8f1e-d44737528b62', N'Dionisia', N'Morales', CAST(N'2011-12-08' AS Date), N'3430864855', N'5526D776-861B-4085-9B5F-91D58221D161', N'13271', N'30170839851')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8ae51153-af95-4255-b1ea-9d2dcd9543af', N'VICTOR', N'Medina', CAST(N'2014-12-15' AS Date), N'5757838620', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'48870', N'39812021501')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8ae58af0-560d-420e-b0ed-29b26a097a93', N'Blanca', N'Pastor', CAST(N'2017-10-20' AS Date), N'7695588214', N'27C89018-0534-480C-B719-5498EEE22D77', N'87569', N'36443678234')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8aec71d0-bdb4-4ad8-9914-f709c3e457f3', N'Jacobo', N'Izquierdo', CAST(N'2001-09-24' AS Date), N'0758209140', N'5526D776-861B-4085-9B5F-91D58221D161', N'29724', N'31886144360')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8b369e28-8c3a-418b-af74-e85f04c14fe8', N'Cisco', N'Carmona', CAST(N'2015-12-17' AS Date), N'9207887989', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'04896', N'34307795930')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8ba30dc9-7d44-4014-b7ab-1b69eb07c8a7', N'Mercedes', N'Gutierrez', CAST(N'2007-02-13' AS Date), N'5438158494', N'27C89018-0534-480C-B719-5498EEE22D77', N'78170', N'36002847410')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8ba46aff-feab-4ad6-acc4-f4dd4cedbe5f', N'Montel', N'Prieto', CAST(N'2009-05-15' AS Date), N'8724430648', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'45372', N'31296243169')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8bbd5f8c-d333-4730-82de-9d4d1d8a47a2', N'Isa', N'Cruz', CAST(N'2003-03-24' AS Date), N'8254645859', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'77544', N'31805091043')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8bc954bb-427c-4024-be57-dc58a3fab780', N'Natividad', N'Vidal', CAST(N'2015-04-05' AS Date), N'1741312218', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'33165', N'34191284082')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8c6eecc5-e3cc-4567-99bb-54d16b65b08b', N'Montego', N'Fernandez', CAST(N'2016-03-17' AS Date), N'6317642029', N'5526D776-861B-4085-9B5F-91D58221D161', N'49416', N'32030013777')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8c740abe-90be-4849-a560-1804717eee0f', N'Teresa', N'Moya', CAST(N'2006-07-27' AS Date), N'3569752260', N'5526D776-861B-4085-9B5F-91D58221D161', N'29340', N'39049753374')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8cbefe2d-d14a-4cda-8b23-65580b287a86', N'Paco', N'Duran', CAST(N'2004-04-07' AS Date), N'1093375623', N'5526D776-861B-4085-9B5F-91D58221D161', N'29630', N'33015892946')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8ccf5502-e0ec-438c-89db-85818c8f84af', N'Clotilde', N'Garcia', CAST(N'2015-10-31' AS Date), N'3714983198', N'5526D776-861B-4085-9B5F-91D58221D161', N'25523', N'39685757193')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8d186f9b-4ed7-4064-84a7-c68d940df65e', N'Ascensión', N'Saez', CAST(N'2014-03-25' AS Date), N'8671669321', N'27C89018-0534-480C-B719-5498EEE22D77', N'10627', N'30499188523')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8d46f27e-b313-410b-8f7a-616cf1ff2c21', N'Bautista', N'Reyes', CAST(N'2017-07-10' AS Date), N'1355510919', N'27C89018-0534-480C-B719-5498EEE22D77', N'68897', N'36699522502')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8d75e762-4428-44cb-9033-47ce7b6fda68', N'Cobura', N'Soto', CAST(N'2001-08-20' AS Date), N'1679338071', N'5526D776-861B-4085-9B5F-91D58221D161', N'56776', N'35278342726')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8d902479-ad1d-4239-8c49-569cd712dc74', N'Lorenza', N'Morales', CAST(N'2004-11-09' AS Date), N'6126639247', N'27C89018-0534-480C-B719-5498EEE22D77', N'77963', N'36454698640')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8d9ce591-b458-43db-b493-4370bed5ecd2', N'Isaac', N'Santos', CAST(N'2009-03-04' AS Date), N'4443858577', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'12173', N'38920542871')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8dffa989-ea2b-49e2-90d9-13d6653b4695', N'Joaquina', N'Carmona', CAST(N'2015-09-16' AS Date), N'9593784690', N'27C89018-0534-480C-B719-5498EEE22D77', N'55628', N'33633249046')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8e145a61-3920-4f15-be4c-cad3faf50108', N'Joaquin', N'Lorenzo', CAST(N'2012-07-03' AS Date), N'1221829368', N'5526D776-861B-4085-9B5F-91D58221D161', N'41775', N'37728122429')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8eb5cc72-6f63-4177-8485-e89373fc5dc0', N'Fermina', N'Romero', CAST(N'2006-09-08' AS Date), N'0450020563', N'5526D776-861B-4085-9B5F-91D58221D161', N'69224', N'38507623223')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8ee095db-4abe-472f-b0e3-f8607730d79e', N'Aina', N'Vazquez', CAST(N'2014-05-02' AS Date), N'7110056910', N'27C89018-0534-480C-B719-5498EEE22D77', N'63581', N'37875056258')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8efb76fa-9ef9-491e-b894-1a029c6d9f2e', N'Helena', N'Ibanez', CAST(N'2010-04-25' AS Date), N'6348868703', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'94593', N'33390082858')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8f10bfec-5bb4-46fc-9953-36a23edcc8fa', N'Fabricia', N'Velasco', CAST(N'2006-02-05' AS Date), N'3129999847', N'27C89018-0534-480C-B719-5498EEE22D77', N'50091', N'37755591757')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8f1286aa-e543-4aa1-8e74-4aee7620b47e', N'Macarena', N'Ramos', CAST(N'2004-04-21' AS Date), N'2698678462', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'81549', N'35467375324')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8f3bd991-b306-4da6-9baa-1dfccecbf17a', N'Juan José', N'Bravo', CAST(N'2001-12-12' AS Date), N'3313316876', N'5526D776-861B-4085-9B5F-91D58221D161', N'43103', N'30341763705')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8f4d2d66-897d-4a37-9462-50d29f669074', N'Juan Esteban', N'Menendez', CAST(N'2003-01-07' AS Date), N'1605960059', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'25739', N'30059770547')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8f74112e-2750-49c2-b72e-48b64d7e53a2', N'Eneko', N'Marin', CAST(N'2003-03-03' AS Date), N'5321589993', N'27C89018-0534-480C-B719-5498EEE22D77', N'37459', N'38629471892')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8f7d99a2-67cc-4433-a1de-f1c52a62529e', N'Gael', N'Guerrero', CAST(N'2010-08-05' AS Date), N'5138215780', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'80830', N'39060628487')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8f9581e4-7f6b-41dd-aed1-28d193871eda', N'Bruno', N'Fernandez', CAST(N'2005-02-03' AS Date), N'5730578295', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'70036', N'34661317091')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8fb51bf3-9b62-455b-aee4-aade8714760e', N'Micaela', N'Montero', CAST(N'2020-04-06' AS Date), N'6481087989', N'27C89018-0534-480C-B719-5498EEE22D77', N'55252', N'36962653438')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8fd509c3-154b-4902-ba4f-511f9f793d92', N'Sergio', N'Iglesias', CAST(N'2001-11-29' AS Date), N'7549989231', N'5526D776-861B-4085-9B5F-91D58221D161', N'64637', N'33396414240')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'8ff45bb0-8964-4375-aece-02252d5062e4', N'Ignado', N'Vazquez', CAST(N'2015-06-01' AS Date), N'2009926887', N'27C89018-0534-480C-B719-5498EEE22D77', N'15923', N'37006923875')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'90a4cff7-1fbf-47f5-90de-a28f6719a991', N'Mari', N'Calvo', CAST(N'2000-08-22' AS Date), N'1876484287', N'5526D776-861B-4085-9B5F-91D58221D161', N'53068', N'37627066199')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'90b3b56f-41c9-4c4d-8e2d-bfc08fe910b6', N'Diana', N'Vazquez', CAST(N'2010-07-30' AS Date), N'8655858246', N'5526D776-861B-4085-9B5F-91D58221D161', N'25422', N'37911512763')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'90beebfc-c56c-4c7c-afd8-3ea87e947649', N'Narcisa', N'Ortiz', CAST(N'2016-03-09' AS Date), N'7102650772', N'27C89018-0534-480C-B719-5498EEE22D77', N'40809', N'30714318497')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'90ee4404-7d09-4c22-aaa7-d2bf15b42ebd', N'Teodora', N'Alvarez', CAST(N'2017-06-15' AS Date), N'0690012294', N'27C89018-0534-480C-B719-5498EEE22D77', N'56520', N'31801826442')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'90f258cd-c2d6-4f11-91b2-495ea80813d7', N'Fulca', N'Lozano', CAST(N'2011-05-18' AS Date), N'4723543256', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'63794', N'39544256000')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'911dcb8d-d638-4bc7-89e6-b13397c93413', N'Blanca', N'Martinez', CAST(N'2005-05-19' AS Date), N'1697776794', N'27C89018-0534-480C-B719-5498EEE22D77', N'84087', N'31949497306')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'914c02e8-67f2-4a79-9546-c4e3a045f3f2', N'Clotilde', N'Ortiz', CAST(N'2001-10-08' AS Date), N'1290427319', N'27C89018-0534-480C-B719-5498EEE22D77', N'14365', N'31161674394')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'914ff2b6-d984-49d7-abf4-bbe372612b12', N'Cecilia', N'Suarez', CAST(N'2007-06-10' AS Date), N'7152698581', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'36669', N'35160723999')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'916755aa-6e0a-4003-a33f-24c599294487', N'Adelina', N'Campos', CAST(N'2006-07-23' AS Date), N'9235139816', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'70549', N'36683224071')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9190e561-e1d9-402e-8274-0bc712801c09', N'Amaya', N'Izquierdo', CAST(N'2013-12-12' AS Date), N'8925750319', N'27C89018-0534-480C-B719-5498EEE22D77', N'05943', N'35872311791')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'91976f83-98ba-455f-8363-8d7152d7c443', N'Soraya', N'Herrero', CAST(N'2008-10-20' AS Date), N'8208251109', N'27C89018-0534-480C-B719-5498EEE22D77', N'87167', N'37425033823')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'91bd5c50-2229-422e-8344-67e60c280cc4', N'María José', N'Arias', CAST(N'2002-03-07' AS Date), N'6555292558', N'27C89018-0534-480C-B719-5498EEE22D77', N'97513', N'31547059967')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'91d9093c-9d2d-4742-ace9-46b719b77b5a', N'Tamara', N'Navarro', CAST(N'2013-02-06' AS Date), N'2694551034', N'5526D776-861B-4085-9B5F-91D58221D161', N'20023', N'34193707335')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'91dd06c7-912a-4484-a94b-472787a3ce90', N'Julen', N'Rey', CAST(N'2017-07-27' AS Date), N'8059559953', N'27C89018-0534-480C-B719-5498EEE22D77', N'25734', N'33797686470')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'91e014e0-c48f-4763-8af8-7a317af49272', N'Caro', N'Perez', CAST(N'2016-04-14' AS Date), N'0888909215', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'08110', N'37038192125')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'924ee610-76fd-4679-bc35-864119dfe982', N'Margarita', N'Carrasco', CAST(N'2010-11-17' AS Date), N'5144356201', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'11002', N'30230955440')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'925bf2f3-abec-4665-b996-a1a895f59150', N'Azucena', N'Aguilar', CAST(N'2013-08-21' AS Date), N'8103904938', N'5526D776-861B-4085-9B5F-91D58221D161', N'53844', N'35271095775')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'92cb0022-44a6-4a5c-b947-1334d50d597d', N'Nasario', N'Cortes', CAST(N'2001-05-20' AS Date), N'9385633404', N'27C89018-0534-480C-B719-5498EEE22D77', N'41397', N'30035584478')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'931c90a5-a6da-45ca-9885-45cb0848c97f', N'Cristóbal', N'Cortes', CAST(N'2017-10-13' AS Date), N'4357182719', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'68820', N'37361155226')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'937bd8ac-1200-4874-8c50-345214f11c4a', N'Lara', N'Marin', CAST(N'2015-09-16' AS Date), N'0192443070', N'27C89018-0534-480C-B719-5498EEE22D77', N'62278', N'31500754317')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'93a3b6bb-c7a3-4e7b-98e5-c68e98650b83', N'Julián', N'Carmona', CAST(N'2021-05-29' AS Date), N'4988941442', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'35544', N'38691078172')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'93c4aa1c-f03d-4288-9920-f1c6c3ee5a4a', N'Ángela', N'Ramos', CAST(N'2021-06-02' AS Date), N'9355594083', N'27C89018-0534-480C-B719-5498EEE22D77', N'02126', N'34623377339')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'93cae116-6d23-460b-8bc1-3e9fff7d0373', N'Pablo', N'Marquez', CAST(N'2021-06-29' AS Date), N'4253441669', N'27C89018-0534-480C-B719-5498EEE22D77', N'99029', N'39414290146')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'93caed5d-e6a2-4678-9272-eb8a33f2d406', N'Raimunda', N'Lorenzo', CAST(N'2002-12-12' AS Date), N'0275353494', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'38518', N'35708879584')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'93dc1179-f041-420b-b5a2-ea9c7a0880a6', N'Javi', N'Diez', CAST(N'2001-09-22' AS Date), N'3106465555', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'22406', N'33750436254')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9401ad44-8fa8-4561-9640-315d33377c3b', N'Miguel Angel', N'Diez', CAST(N'2016-03-05' AS Date), N'1135898098', N'5526D776-861B-4085-9B5F-91D58221D161', N'65792', N'37717360633')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'94492ee5-a950-4a4a-be5a-1e88bb59d741', N'Lourdes', N'Marquez', CAST(N'2008-09-04' AS Date), N'4035938031', N'27C89018-0534-480C-B719-5498EEE22D77', N'18286', N'32669556417')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'944f4e13-a57f-4edd-8a45-38b4c13241e0', N'Manolo', N'Moya', CAST(N'2004-06-23' AS Date), N'9868957871', N'5526D776-861B-4085-9B5F-91D58221D161', N'38976', N'31881929932')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9486349b-0197-4285-859b-b2e946eb9dcf', N'Felipa', N'Ortiz', CAST(N'2013-11-11' AS Date), N'8386976318', N'5526D776-861B-4085-9B5F-91D58221D161', N'40746', N'39637446852')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9491ce83-fc35-4f86-a327-9292140eba91', N'Adelina', N'Ruiz', CAST(N'2006-11-27' AS Date), N'5954508682', N'5526D776-861B-4085-9B5F-91D58221D161', N'69334', N'36519064828')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'949e9a8c-b331-4ee2-a771-f33b58a83edb', N'Agapetus', N'Pastor', CAST(N'2005-05-08' AS Date), N'7759048763', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'39266', N'36389885004')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'94c7ef33-b6c7-47ab-9247-f7c90dc5ab8a', N'Axel', N'Iglesias', CAST(N'2017-04-17' AS Date), N'9934031327', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'08946', N'34124862469')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9522b938-58fc-4d53-87dd-e643f97752aa', N'Luciano', N'Lozano', CAST(N'2009-12-07' AS Date), N'7677023154', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'71427', N'35138441038')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9530f97c-6c4b-465b-9a26-5df476198d82', N'Adrián', N'Nieto', CAST(N'2004-11-25' AS Date), N'1002950839', N'27C89018-0534-480C-B719-5498EEE22D77', N'23249', N'32075944145')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'95e014d4-bf3c-4142-88ff-ea66ab9a68a0', N'Agapetus', N'Velasco', CAST(N'2018-03-08' AS Date), N'7431100798', N'27C89018-0534-480C-B719-5498EEE22D77', N'76637', N'33565756297')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'95ef38c4-ca04-45ff-9fd6-981d760249b4', N'Bronco', N'Cortes', CAST(N'2019-06-11' AS Date), N'2275970972', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'02440', N'33197326460')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'95f395a6-c54f-4303-a6c1-4abc0a340c4a', N'Kiki', N'Cortes', CAST(N'2012-04-22' AS Date), N'8506996265', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'65407', N'34745092497')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'960362ea-624f-4fdf-9c02-0b5639cc4825', N'Luis', N'Pena', CAST(N'2003-12-16' AS Date), N'5504798665', N'27C89018-0534-480C-B719-5498EEE22D77', N'33138', N'35824711319')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'962e391d-d817-4ad4-b33f-520d0c748203', N'Bautista', N'Caballero', CAST(N'2016-04-05' AS Date), N'3535725697', N'5526D776-861B-4085-9B5F-91D58221D161', N'97246', N'35430067615')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9644f077-9a26-4337-92f9-e564744d98f6', N'Joaquín', N'Flores', CAST(N'2003-11-09' AS Date), N'9132064603', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'59409', N'30762272391')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'964bc85e-39b5-4034-9ef4-97abd394dcde', N'Miguela', N'Vazquez', CAST(N'2016-12-28' AS Date), N'0093031049', N'27C89018-0534-480C-B719-5498EEE22D77', N'65914', N'39511037802')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'965b2826-b260-463e-88ea-728d2823eb28', N'Nora', N'Pardo', CAST(N'2000-02-16' AS Date), N'0386303985', N'5526D776-861B-4085-9B5F-91D58221D161', N'32034', N'32460140803')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'96a33a79-a3f5-49b7-be24-334a54b3ebb3', N'Alma', N'Vazquez', CAST(N'2008-01-06' AS Date), N'1791738671', N'27C89018-0534-480C-B719-5498EEE22D77', N'35413', N'38693722569')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'96a57b30-d363-4a33-85a0-e19b99dc5749', N'Fabricia', N'Martin', CAST(N'2001-06-15' AS Date), N'7605771188', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'73942', N'36952943282')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9703a31c-74c0-42ad-8e3b-cf893d4b2a91', N'Montel', N'Ibanez', CAST(N'2007-10-29' AS Date), N'7196069274', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'82486', N'32947929918')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9707319c-624a-4e4d-806b-c4692df1858b', N'Paco', N'Cabrera', CAST(N'2005-01-25' AS Date), N'7779261279', N'27C89018-0534-480C-B719-5498EEE22D77', N'66321', N'38869839328')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9717384d-71ed-4c65-89c4-5508edca065a', N'Rosalía', N'Cano', CAST(N'2017-01-25' AS Date), N'4031399873', N'5526D776-861B-4085-9B5F-91D58221D161', N'51486', N'39730371374')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'972a8108-bea3-424b-8160-8f2e45493fd0', N'Jacobo', N'Lozano', CAST(N'2007-06-09' AS Date), N'7722120910', N'5526D776-861B-4085-9B5F-91D58221D161', N'73004', N'37111308363')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'975ecbac-b51d-4ac3-86ca-1fe74f9b68a0', N'Montego', N'Pardo', CAST(N'2017-08-26' AS Date), N'9228800585', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'16254', N'34944434651')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9792e0e7-604c-4c53-ab5c-3476ce938bce', N'Florencia', N'Ferrer', CAST(N'2020-05-14' AS Date), N'6795432464', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'75021', N'39391044480')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'97e123df-c6f0-4e24-851c-ed4a3091b6b8', N'Clara', N'Marcos', CAST(N'2009-05-07' AS Date), N'9668359696', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'28854', N'39341457758')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'97ebe11b-ef9f-423c-9c63-0a45b3a5c24e', N'Judith', N'Mendez', CAST(N'2009-08-13' AS Date), N'8047794042', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'35633', N'33462158341')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'98311352-558f-40d8-8e35-1d1388cabafd', N'Hernan', N'Arias', CAST(N'2013-01-14' AS Date), N'6730713343', N'5526D776-861B-4085-9B5F-91D58221D161', N'46886', N'33276917183')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'984ff03c-9b4e-4d7b-9413-74d61be2b03a', N'Alexander', N'Serrano', CAST(N'2003-09-05' AS Date), N'5101397354', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'00150', N'32358986367')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'98789e82-8dbe-4607-a6f5-f0875ba7c3d0', N'Joaquina', N'Molina', CAST(N'2004-12-26' AS Date), N'4463497678', N'27C89018-0534-480C-B719-5498EEE22D77', N'90394', N'39220166409')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'98b165e8-df84-4ee4-b0f3-aad4ad24fd5a', N'Gabriel', N'Ruiz', CAST(N'2005-04-25' AS Date), N'7066054879', N'5526D776-861B-4085-9B5F-91D58221D161', N'11800', N'30638791088')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'98dd623a-bc81-41e7-b960-b8a3e6c0824d', N'Haydée', N'Vila', CAST(N'2009-06-08' AS Date), N'5532730750', N'27C89018-0534-480C-B719-5498EEE22D77', N'41284', N'31803760115')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9946a92d-22df-4467-a861-cfee53e3dea7', N'Hañagua', N'Herrera', CAST(N'2011-04-12' AS Date), N'8673175958', N'27C89018-0534-480C-B719-5498EEE22D77', N'57372', N'33118690971')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'99609442-c0e5-4c36-bb15-5733ec466a00', N'Ilda', N'Arias', CAST(N'2020-06-04' AS Date), N'0964837571', N'27C89018-0534-480C-B719-5498EEE22D77', N'17239', N'37280953422')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9968a7a7-21d2-4e1d-8539-d2853be9f98f', N'Rosa', N'Saez', CAST(N'2002-10-30' AS Date), N'5621056143', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'62590', N'39551666531')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9971efeb-18ec-4bdf-9e22-f74e9abde73f', N'Bautista', N'Roman', CAST(N'2000-12-06' AS Date), N'5456104261', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'39884', N'36710484665')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9973f24e-98a2-4712-8f8b-d4323df2c73d', N'Marta', N'Jimenez', CAST(N'2004-07-13' AS Date), N'9114611753', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'54148', N'36254705500')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'997925fa-5c3e-4032-b7ee-d2e8a1e2eced', N'Beltran', N'Torres', CAST(N'2001-08-08' AS Date), N'2926953916', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'09441', N'34294915254')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'99928870-30de-42f5-bc9d-9d1d4ac637cf', N'Lolita', N'Vicente', CAST(N'2020-09-25' AS Date), N'4803385189', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'67702', N'37797619593')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9994a7ac-67d0-41ce-befe-cf9333719098', N'Juan David', N'Gutierrez', CAST(N'2007-05-07' AS Date), N'3197214982', N'27C89018-0534-480C-B719-5498EEE22D77', N'24257', N'33012279850')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'99bd0489-9419-4b54-8d46-77b1626cef44', N'Alejandro', N'Cortes', CAST(N'2019-12-27' AS Date), N'8372203899', N'27C89018-0534-480C-B719-5498EEE22D77', N'71201', N'30776650883')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'99f7b8db-27c0-4c3c-8bd6-db0aa2204a38', N'Jerónimo/Gerónimo', N'Hidalgo', CAST(N'2013-02-02' AS Date), N'9020247876', N'27C89018-0534-480C-B719-5498EEE22D77', N'16267', N'33952666275')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9a1ab525-9e9b-4672-9bb2-ef67c7fe39d2', N'Montel', N'Gomez', CAST(N'2014-11-22' AS Date), N'2589468602', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'30034', N'30806270750')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9a1cfe99-1952-42c9-accb-c38ebfe1d8b5', N'Caleb', N'Diaz', CAST(N'2011-02-27' AS Date), N'7195829577', N'5526D776-861B-4085-9B5F-91D58221D161', N'03586', N'39290752745')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9a4c6354-cf0e-4165-9422-d4cdf9e25c03', N'Úrsula', N'Gomez', CAST(N'2006-01-17' AS Date), N'0089814171', N'27C89018-0534-480C-B719-5498EEE22D77', N'33058', N'35490927891')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9a6955eb-6f59-4aec-99ff-2d4b0440f87e', N'Ana', N'Cano', CAST(N'2009-03-06' AS Date), N'7560747775', N'27C89018-0534-480C-B719-5498EEE22D77', N'83348', N'31304696270')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9aa59172-f39c-4c52-9a7a-731a53e3b15d', N'Ana', N'Gimenez', CAST(N'2008-05-26' AS Date), N'2261754679', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'11803', N'39839254638')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9ad9876f-fc12-4898-bbb1-612b710073ad', N'Emmanuel', N'Soler', CAST(N'2012-05-03' AS Date), N'5877435746', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'79166', N'36992314512')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9b038e87-e1a0-4571-970e-c08ae768b4b9', N'Sofía', N'Nieto', CAST(N'2008-08-16' AS Date), N'9451207857', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'36088', N'38145366882')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9b0879ff-dba2-4551-971d-f94e275f08ab', N'Jerrold', N'Rodriguez', CAST(N'2002-10-26' AS Date), N'5044283938', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'95709', N'30285804485')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9b301b0c-b762-472e-aa18-ecf201915a9f', N'Paulette', N'Hidalgo', CAST(N'2012-06-12' AS Date), N'0014865758', N'27C89018-0534-480C-B719-5498EEE22D77', N'19688', N'30826116784')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9b3d8682-9cc4-46ce-9e8c-146f5abab776', N'Santiago', N'Bravo', CAST(N'2016-12-26' AS Date), N'0554835911', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'64010', N'34841946077')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9b4d3a2c-87a1-48e2-ab0c-671440463e85', N'Luna', N'Lorenzo', CAST(N'2020-04-12' AS Date), N'9121553267', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'12081', N'33135299128')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9b5f8e93-ef11-4d75-856c-8fc463a13682', N'Pepe', N'Calvo', CAST(N'2000-05-24' AS Date), N'0466944383', N'5526D776-861B-4085-9B5F-91D58221D161', N'92237', N'35889326551')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9b68109d-7a3b-4b05-ae2c-308d1b8c5f3e', N'Liliana', N'Ortega', CAST(N'2003-03-12' AS Date), N'7813300190', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'57381', N'33559209870')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9b71d4a3-4259-433b-88cc-a5fb49992a1b', N'Alexandra', N'Ruiz', CAST(N'2004-06-26' AS Date), N'1883079530', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'18017', N'32864110345')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9bb5b50c-db01-46f0-993c-bf12f59422f1', N'Paco', N'Pena', CAST(N'2002-03-24' AS Date), N'9928761017', N'27C89018-0534-480C-B719-5498EEE22D77', N'74276', N'30589525407')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9bc67862-107c-4f46-be01-751a7d6bdf66', N'Lucas', N'Name', CAST(N'2000-04-30' AS Date), N'7155099086', N'27C89018-0534-480C-B719-5498EEE22D77', N'02026', N'35006697371')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9c0d854e-d010-41cf-8a06-5fdb91376038', N'Karina', N'Lorenzo', CAST(N'2000-10-27' AS Date), N'3433069966', N'27C89018-0534-480C-B719-5498EEE22D77', N'51751', N'30785333307')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9c20a7e2-8386-4770-9fb4-a46e35e75206', N'Blanca', N'Ferrer', CAST(N'2008-07-01' AS Date), N'0595328678', N'27C89018-0534-480C-B719-5498EEE22D77', N'95543', N'38987473245')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9c22fc29-e0af-46ce-85b5-d21c6f6a0638', N'Nilda', N'Ruiz', CAST(N'2009-12-29' AS Date), N'5488891082', N'27C89018-0534-480C-B719-5498EEE22D77', N'85877', N'34650837253')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9c580f8b-810b-4643-ba3d-f46620ff628b', N'Vicenta', N'Roman', CAST(N'2002-10-12' AS Date), N'5699724994', N'27C89018-0534-480C-B719-5498EEE22D77', N'88656', N'39717367426')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9c85af33-e641-47d6-b911-3f88b41f8a16', N'Cisco', N'Vega', CAST(N'2002-08-19' AS Date), N'9572250133', N'27C89018-0534-480C-B719-5498EEE22D77', N'14264', N'38274549569')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9ce7e7fd-de81-4296-9569-080815143419', N'Dayana', N'Ramirez', CAST(N'2010-02-16' AS Date), N'0474554603', N'5526D776-861B-4085-9B5F-91D58221D161', N'16624', N'34916099168')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9d04df17-78e6-4923-891d-45456a702e6d', N'Leonardo', N'Ferrer', CAST(N'2008-05-26' AS Date), N'4117918959', N'27C89018-0534-480C-B719-5498EEE22D77', N'50294', N'32652479511')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9d1f6a2b-6ff9-48f1-8ce8-fddcc956cd84', N'Rodrigo', N'Rey', CAST(N'2017-04-20' AS Date), N'0336457541', N'5526D776-861B-4085-9B5F-91D58221D161', N'02542', N'30020909608')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9d3c9bc8-e3f5-4428-bf19-a49a3927b3df', N'Ginebra', N'Molina', CAST(N'2016-08-27' AS Date), N'6144381349', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'96169', N'32831921906')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9d48728b-4c36-49ea-81da-f9aee2dcdef0', N'Uxue', N'Hernandez', CAST(N'2010-01-02' AS Date), N'3760468783', N'27C89018-0534-480C-B719-5498EEE22D77', N'13348', N'34763697199')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9d4e2134-8499-4290-8cd6-a57086ea4828', N'Daniela', N'Nunez', CAST(N'2014-06-10' AS Date), N'1944277925', N'27C89018-0534-480C-B719-5498EEE22D77', N'07099', N'37230186983')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9d69af5e-9130-4b0e-b12b-36c54e688fff', N'Desiderio', N'Ferrer', CAST(N'2009-11-04' AS Date), N'7429670999', N'5526D776-861B-4085-9B5F-91D58221D161', N'39291', N'39028697838')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9d7b49ce-70b5-4082-b212-2e41966b7343', N'Álvara', N'Ramos', CAST(N'2007-01-16' AS Date), N'4319293845', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'88518', N'35144220719')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9d9fe0ea-335b-4cda-b9e2-b5b9998c151c', N'Lisandro', N'Vazquez', CAST(N'2000-06-12' AS Date), N'4348093358', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'57645', N'38192219088')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9e02ed09-759e-431c-a3fc-f1ec1180a3ca', N'Kevin', N'Navarro', CAST(N'2009-07-28' AS Date), N'4351412961', N'5526D776-861B-4085-9B5F-91D58221D161', N'93241', N'38937532183')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9e03e3b8-1bd1-481c-a32f-d59a051b5021', N'María', N'Marin', CAST(N'2000-04-11' AS Date), N'5120250752', N'27C89018-0534-480C-B719-5498EEE22D77', N'95176', N'37531455643')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9e0a5bb5-5057-4ae6-94b5-bc8617d0d342', N'Lola', N'Lozano', CAST(N'2020-12-09' AS Date), N'4966415996', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'83157', N'32211570459')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9e23dd92-88e1-4ca8-a0bf-719fdfc80e65', N'First names', N'Gil', CAST(N'2019-01-02' AS Date), N'2735513689', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'71164', N'38402092772')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9e3bdd74-36e5-490c-ab81-fa44d2d76a82', N'Adelia', N'Alonso', CAST(N'2020-07-31' AS Date), N'6504179692', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'41358', N'36324731569')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9e82e9d1-bcf0-4597-b137-8bf0dfc8fee7', N'Feliciana', N'Gimenez', CAST(N'2004-09-27' AS Date), N'8908836143', N'27C89018-0534-480C-B719-5498EEE22D77', N'95786', N'30611626664')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9ec59293-11f8-4248-a8a0-f9bd6bdef565', N'Valentino', N'Leon', CAST(N'2003-12-05' AS Date), N'1976583946', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'12082', N'30195118784')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9f37f0ff-4e9e-4ab9-bea1-7b10a867cd34', N'Gretel', N'Garcia', CAST(N'2002-07-21' AS Date), N'8235390655', N'5526D776-861B-4085-9B5F-91D58221D161', N'49592', N'30364272573')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9f4d5e1e-b171-4403-8c44-30e071af041b', N'Nora', N'Alvarez', CAST(N'2007-12-24' AS Date), N'2321337962', N'27C89018-0534-480C-B719-5498EEE22D77', N'13985', N'32622474230')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9f9185f5-6274-4629-9c91-ca5674abe210', N'Rosa', N'Moya', CAST(N'2002-01-17' AS Date), N'9298769931', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'87722', N'31959545969')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9fc0aae1-2a06-4cc2-9dfe-aaaa8da264b4', N'Carlos', N'Vidal', CAST(N'2000-11-28' AS Date), N'4141783060', N'27C89018-0534-480C-B719-5498EEE22D77', N'60626', N'34772137998')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9fcc43aa-9768-46f4-9ba1-5190d7dfe0f5', N'Lola', N'Sanchez', CAST(N'2000-08-09' AS Date), N'7780023077', N'5526D776-861B-4085-9B5F-91D58221D161', N'23424', N'32219389622')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9fcc5607-8bec-49da-9da3-e1ef0333bc6a', N'Martín', N'Moya', CAST(N'2018-03-27' AS Date), N'3802195902', N'5526D776-861B-4085-9B5F-91D58221D161', N'94754', N'33887214655')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9fd8483c-b7b1-4709-b343-d5dabf515a93', N'Ainoa', N'Garcia', CAST(N'2006-01-21' AS Date), N'8064741677', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'71961', N'35244143832')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9feda242-e086-4232-a981-f84b89d3d79a', N'Abigaíl', N'Herrero', CAST(N'2004-10-18' AS Date), N'3915865184', N'5526D776-861B-4085-9B5F-91D58221D161', N'08549', N'37742861413')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'9ff2012a-f0c1-458e-bacb-0594c3dad935', N'Verónica', N'Delgado', CAST(N'2017-09-16' AS Date), N'1066605962', N'27C89018-0534-480C-B719-5498EEE22D77', N'25200', N'31483112084')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a0106865-0d70-4533-b8fb-8e52d4225178', N'Xalvador', N'Rubio', CAST(N'2003-09-28' AS Date), N'0502904292', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'29020', N'35949208379')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a0120b78-d9e0-462c-82cf-b719bf49bc30', N'Dalila', N'Sanz', CAST(N'2008-04-22' AS Date), N'3715184073', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'64684', N'33125202290')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a01a4ad2-c611-4529-90d3-7d7dde16ae62', N'José', N'Merino', CAST(N'2003-04-05' AS Date), N'1726748574', N'5526D776-861B-4085-9B5F-91D58221D161', N'95920', N'31205435977')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a0767e13-eefe-45ae-a8bf-05dfc49e487a', N'Raul', N'Castro', CAST(N'2018-01-30' AS Date), N'3979759878', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'17498', N'37317208717')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a12f64d2-17cb-40b6-9166-18a80e2ec0c9', N'Nacho', N'Name', CAST(N'2000-09-25' AS Date), N'5805324350', N'27C89018-0534-480C-B719-5498EEE22D77', N'83512', N'31126804952')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a16a983f-b4e9-4594-938d-15608156e37d', N'Aurelia', N'Ferrer', CAST(N'2013-06-08' AS Date), N'7019759116', N'27C89018-0534-480C-B719-5498EEE22D77', N'61095', N'30401006632')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a19b0da2-4830-4ab2-8ee4-035178639994', N'Mery', N'Diaz', CAST(N'2013-01-24' AS Date), N'9004205069', N'27C89018-0534-480C-B719-5498EEE22D77', N'88198', N'35256506607')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a19b24e4-7a94-4c00-a0e1-a07744bcb67b', N'Licha', N'Pardo', CAST(N'2016-09-28' AS Date), N'3498909059', N'27C89018-0534-480C-B719-5498EEE22D77', N'79806', N'30315625858')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a1d825dd-f080-4b5a-bc66-a44244e4a2d6', N'Asier', N'Cruz', CAST(N'2018-12-05' AS Date), N'0728456277', N'27C89018-0534-480C-B719-5498EEE22D77', N'17950', N'35703594967')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a209af20-b7ce-40fd-b3c9-43645a829579', N'Guillermo', N'Leon', CAST(N'2007-06-20' AS Date), N'2893667244', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'24914', N'32708617374')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a21d18ab-6482-477b-ab01-53956e5a040e', N'Loredo', N'Alonso', CAST(N'2001-11-13' AS Date), N'9300801393', N'5526D776-861B-4085-9B5F-91D58221D161', N'01822', N'38835137519')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a282cac0-52b5-44ff-8d4e-df070d69e37b', N'Flora', N'Blanco', CAST(N'2018-10-19' AS Date), N'3433659652', N'5526D776-861B-4085-9B5F-91D58221D161', N'64105', N'37202773417')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a28c74b9-dd6b-4bd2-b7fc-ce103bc383a2', N'Nemesio', N'Cruz', CAST(N'2014-10-11' AS Date), N'4705218246', N'5526D776-861B-4085-9B5F-91D58221D161', N'28288', N'36224917251')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a2acfcf5-2cfe-4994-b8f6-374afa0a1a22', N'Pilar', N'Delgado', CAST(N'2013-02-11' AS Date), N'5786222951', N'5526D776-861B-4085-9B5F-91D58221D161', N'19440', N'34772376051')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a2b90179-6b7a-41bd-b903-d36e3264c95c', N'Lolita', N'Pascual', CAST(N'2015-02-20' AS Date), N'6837301433', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'61181', N'35459626544')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a2e85703-60b0-4192-8849-55a650e432ee', N'Julián', N'Andres', CAST(N'2021-08-10' AS Date), N'7696563774', N'5526D776-861B-4085-9B5F-91D58221D161', N'18738', N'31905860081')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a352bcaa-1f9c-463d-b882-33bc726e285e', N'Belen', N'Cano', CAST(N'2012-09-04' AS Date), N'0251289889', N'27C89018-0534-480C-B719-5498EEE22D77', N'21950', N'31474456278')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a3e1b85f-d505-43d8-9da8-0347967b7510', N'Máximo', N'Crespo', CAST(N'2016-07-01' AS Date), N'6365061573', N'27C89018-0534-480C-B719-5498EEE22D77', N'99962', N'38741576760')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a401afb4-d273-4aea-87ab-d64192825e83', N'Pedro', N'Pardo', CAST(N'2017-04-01' AS Date), N'3531805007', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'62144', N'31880121048')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a43e6d4a-bf88-496d-817d-f64d68616f4a', N'Gonzalo', N'Pardo', CAST(N'2007-04-10' AS Date), N'6013559765', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'87828', N'33224408986')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a4505158-b9b3-472e-af03-7e7146bbc277', N'Berto', N'Diaz', CAST(N'2017-09-28' AS Date), N'1662829992', N'27C89018-0534-480C-B719-5498EEE22D77', N'37249', N'34994127032')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a4a2cc69-6e75-4c97-8b85-f058cf1de9fb', N'Olga', N'Ramos', CAST(N'2020-09-27' AS Date), N'4709086828', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'95071', N'34098162649')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a4a451e7-ed3a-4508-b63a-4e6f07cd5ce1', N'Juan Pablo', N'Crespo', CAST(N'2007-07-24' AS Date), N'3505565733', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'96082', N'37003544532')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a4c5c947-41a1-4cda-ad0f-0f1c4c2bafb4', N'Thiago', N'Izquierdo', CAST(N'2006-11-26' AS Date), N'5605739835', N'27C89018-0534-480C-B719-5498EEE22D77', N'14175', N'30570587204')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a4ce8b2e-6862-448c-89c3-35c920554c93', N'Hortensia', N'Castillo', CAST(N'2019-12-09' AS Date), N'0372897775', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'83591', N'31241587644')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a4e648cc-d3ee-4e91-9568-917f533d6b80', N'Emilio', N'Name', CAST(N'2011-04-17' AS Date), N'1630123424', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'34407', N'31191726158')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a50e8f6a-3364-4c58-9162-57284f623995', N'Roxana', N'Name', CAST(N'2012-11-10' AS Date), N'6634238198', N'5526D776-861B-4085-9B5F-91D58221D161', N'60472', N'32585688380')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a51602bf-9ea6-41e1-a52b-73fef4cf9b92', N'Andy', N'Montero', CAST(N'2000-12-19' AS Date), N'5831662919', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'22828', N'34941532086')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a52b4eab-c334-42ac-b200-d103729a0252', N'Felipe', N'Arias', CAST(N'2004-02-10' AS Date), N'8659551601', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'16805', N'31605919009')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a57eda35-6e26-4c5b-b004-8fbaa7953d25', N'Mireya', N'Soto', CAST(N'2020-07-16' AS Date), N'9263321663', N'5526D776-861B-4085-9B5F-91D58221D161', N'30253', N'38156094618')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a5c71285-5cc1-48bd-9fff-9cb7668828b3', N'Emilio', N'Montero', CAST(N'2018-03-19' AS Date), N'9986356574', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'10643', N'38146652926')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a616b4ff-95de-4826-b8cd-01fd12d15dc8', N'Desamparados', N'Name', CAST(N'2007-01-15' AS Date), N'7807665503', N'27C89018-0534-480C-B719-5498EEE22D77', N'22443', N'30216413633')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a6465dfa-5a97-422d-9afc-f28047c94a3a', N'Javiera', N'Cano', CAST(N'2019-09-20' AS Date), N'3901704181', N'5526D776-861B-4085-9B5F-91D58221D161', N'28667', N'37163265089')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a6535dc8-614e-41a8-8ca5-a3d568f8b22e', N'Clotilde', N'Vidal', CAST(N'2001-11-03' AS Date), N'1437967753', N'5526D776-861B-4085-9B5F-91D58221D161', N'71335', N'33496664276')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a67076d0-2712-423d-8743-39b39ba3b5dc', N'Gael', N'Navarro', CAST(N'2000-12-10' AS Date), N'7349653098', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'50310', N'31119994277')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a6a96580-870a-4352-bd48-d78f1e23aabf', N'Guadalupe', N'Ruiz', CAST(N'2007-08-13' AS Date), N'0349138084', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'48704', N'31764851566')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a6b3e786-95de-424d-85d0-327dbc705b6c', N'Nieves', N'Navarro', CAST(N'2000-02-07' AS Date), N'2906652404', N'5526D776-861B-4085-9B5F-91D58221D161', N'58040', N'32410306808')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a6d33b1b-c947-4d8d-852d-099170ff226d', N'Ivan', N'Montero', CAST(N'2015-08-18' AS Date), N'2850669045', N'27C89018-0534-480C-B719-5498EEE22D77', N'91448', N'30575299059')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a6f0e492-ad40-43a5-9d08-d02692da7da3', N'Fernando', N'Ortiz', CAST(N'2006-08-31' AS Date), N'1636375930', N'5526D776-861B-4085-9B5F-91D58221D161', N'16725', N'38158179402')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a6f9dbd1-3ea0-4cda-95d2-7b75b492ae2d', N'Jon', N'Iglesias', CAST(N'2011-10-16' AS Date), N'9821587533', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'42037', N'34577780957')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a70f7a04-dd66-4f22-aa5c-d5c6feadf55f', N'Emma', N'Hernandez', CAST(N'2003-03-21' AS Date), N'1324567922', N'27C89018-0534-480C-B719-5498EEE22D77', N'43578', N'33458992298')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a70fd0da-0938-4028-bedf-a8bcd4ca0573', N'Flavia', N'Name', CAST(N'2011-05-21' AS Date), N'7597821443', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'86701', N'37390917511')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a71e8445-ad99-48ab-a8a6-138d8ce35725', N'Montego', N'Alonso', CAST(N'2021-05-03' AS Date), N'3718465607', N'27C89018-0534-480C-B719-5498EEE22D77', N'22858', N'31472967868')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a72633c6-62a9-4bb1-89dd-36bf1ef8521b', N'Benjamín', N'Rubio', CAST(N'2007-07-27' AS Date), N'2353053458', N'27C89018-0534-480C-B719-5498EEE22D77', N'60048', N'35056320005')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a72db43c-eaf7-4c9f-b285-7cbcb6a3f1a7', N'Gabriel', N'Velasco', CAST(N'2013-05-26' AS Date), N'4904190413', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'05498', N'39789116903')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a7769e85-1a46-49fc-a1c0-8e69cc564f68', N'Juan David', N'Moya', CAST(N'2010-04-23' AS Date), N'4345260942', N'27C89018-0534-480C-B719-5498EEE22D77', N'53232', N'34892885145')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a7bb4874-bc51-429c-a82b-ebb2b86ec8b2', N'Emelda', N'Aguilar', CAST(N'2013-12-28' AS Date), N'6987486012', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'14741', N'39882531143')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a7d92e00-c10b-4871-8194-8f6ac8de1146', N'Guillermo', N'Ibanez', CAST(N'2011-09-14' AS Date), N'2681918151', N'27C89018-0534-480C-B719-5498EEE22D77', N'71203', N'30099423331')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a808b555-a666-4d98-bf7f-aa2966c8a504', N'Fatima', N'Sanchez', CAST(N'2002-01-23' AS Date), N'3488000405', N'27C89018-0534-480C-B719-5498EEE22D77', N'39707', N'36345658500')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a8b57cd9-2ea1-4ee3-8841-2e4ed4bb9a79', N'Matthew', N'Alonso', CAST(N'2000-05-23' AS Date), N'0140025955', N'27C89018-0534-480C-B719-5498EEE22D77', N'93388', N'32321011466')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a8ca82f0-270f-4e66-a66c-94e95e457be6', N'Matías', N'Rubio', CAST(N'2002-10-31' AS Date), N'2111305433', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'01152', N'37739660717')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a8e47e11-126b-46e2-a4e5-5f35c9a718c5', N'Verónica', N'Alonso', CAST(N'2020-07-17' AS Date), N'0888287861', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'80982', N'35481137371')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a8e77e0a-772c-4e1a-a7a2-04e3a44c1153', N'Kevin', N'Iglesias', CAST(N'2019-05-25' AS Date), N'8470638033', N'5526D776-861B-4085-9B5F-91D58221D161', N'47514', N'33927932192')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a8ea3e6d-82f3-431e-adbc-a07a32c97597', N'Rosa', N'Blanco', CAST(N'2006-01-12' AS Date), N'5839080432', N'5526D776-861B-4085-9B5F-91D58221D161', N'56883', N'36991499620')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a94f965b-8626-42b0-abac-814fd28f4d54', N'Consuelo', N'Sanchez', CAST(N'2006-03-25' AS Date), N'2240571518', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'02879', N'31938461364')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a99541dc-fe87-4540-8697-933aed110aef', N'Jose manuel', N'Flores', CAST(N'2007-04-19' AS Date), N'5144224736', N'27C89018-0534-480C-B719-5498EEE22D77', N'57644', N'35379579168')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a9b00743-f63e-4fb2-836c-70eb456ca7f2', N'Juan Pablo', N'Morales', CAST(N'2009-12-17' AS Date), N'3319311874', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'01213', N'36480022192')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a9e618e8-c8c8-43c9-8519-e43654e9beb0', N'Beñat', N'Ortiz', CAST(N'2010-07-13' AS Date), N'5905202606', N'27C89018-0534-480C-B719-5498EEE22D77', N'94606', N'33222568401')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'a9f33553-4e3b-48e3-9e0a-10c4b208ef52', N'Jacobo', N'Vazquez', CAST(N'2002-08-29' AS Date), N'9063707617', N'5526D776-861B-4085-9B5F-91D58221D161', N'87961', N'30887236903')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'aa0903df-f63f-4711-a331-ac89d3d00b7e', N'Joan', N'Rey', CAST(N'2005-12-25' AS Date), N'3746757847', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'76482', N'36916589127')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'aa24bcec-5b51-41c7-8601-b7fe98265d8b', N'Adrián', N'Cabrera', CAST(N'2012-08-31' AS Date), N'6290841308', N'27C89018-0534-480C-B719-5498EEE22D77', N'88235', N'39949606135')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'aa3283a3-ca55-4fae-b6af-8ac1b1090f31', N'Daniel', N'Sanz', CAST(N'2012-06-20' AS Date), N'2562648353', N'5526D776-861B-4085-9B5F-91D58221D161', N'60216', N'34430157595')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'aa4c0008-f9d9-4264-b311-29fbe5c931e0', N'Iker', N'Cortes', CAST(N'2016-07-29' AS Date), N'1997873475', N'5526D776-861B-4085-9B5F-91D58221D161', N'50690', N'36864298022')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'aac68778-1803-412c-b947-59dde5bfad11', N'Juan', N'Merino', CAST(N'2003-03-04' AS Date), N'3043125089', N'27C89018-0534-480C-B719-5498EEE22D77', N'37839', N'34849246429')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'aad11b1d-22b9-44e2-a84e-8e190d4b8a83', N'Débora', N'Moya', CAST(N'2007-08-13' AS Date), N'0533969524', N'27C89018-0534-480C-B719-5498EEE22D77', N'21872', N'31506198559')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'aaf8041b-8a5a-4cc4-aff1-ab9209a4020d', N'Alicia', N'Pena', CAST(N'2003-02-04' AS Date), N'6564375970', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'53373', N'33556151607')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'aafd0d65-e3b7-4b0b-bc71-c694c9e8db79', N'Luis', N'Menendez', CAST(N'2017-05-13' AS Date), N'7248239236', N'27C89018-0534-480C-B719-5498EEE22D77', N'38908', N'38446417350')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ab29b1d4-4e75-4894-bcc0-e40640c411f5', N'Hugo', N'Soto', CAST(N'2011-06-10' AS Date), N'2406450514', N'5526D776-861B-4085-9B5F-91D58221D161', N'77363', N'36373564729')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ab2fdbed-cbf5-4253-ae26-89a7c9fb2269', N'Clotilde', N'Soler', CAST(N'2015-01-02' AS Date), N'7946470364', N'27C89018-0534-480C-B719-5498EEE22D77', N'72710', N'35686979129')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ab35b6e4-ccf8-4fa1-9619-029ecb657eb2', N'Juan David', N'Reyes', CAST(N'2019-07-24' AS Date), N'4710510247', N'5526D776-861B-4085-9B5F-91D58221D161', N'86360', N'35489107978')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ab3b3dcb-f660-4298-8af7-1bab839ffb92', N'Victoria', N'Vila', CAST(N'2019-04-27' AS Date), N'3041630480', N'27C89018-0534-480C-B719-5498EEE22D77', N'52360', N'32250351501')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ab4e6fac-2dc4-4d0e-be66-b83f331d1902', N'Ivan', N'Ortega', CAST(N'2003-11-13' AS Date), N'1251257106', N'27C89018-0534-480C-B719-5498EEE22D77', N'76064', N'34597486734')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ab55059b-0aff-49f4-b337-3c97c2b70c13', N'Lali', N'Izquierdo', CAST(N'2002-05-28' AS Date), N'8745361861', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'09622', N'34083187390')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ab671447-dcd9-4544-a8ef-1929276f0a52', N'Leonardo', N'Alonso', CAST(N'2008-08-03' AS Date), N'0112217648', N'5526D776-861B-4085-9B5F-91D58221D161', N'69892', N'32443366907')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ab8fed6a-4cd5-4fc0-a126-ac9f1fbbda9a', N'Abigaíl', N'Vazquez', CAST(N'2010-10-29' AS Date), N'1165369156', N'27C89018-0534-480C-B719-5498EEE22D77', N'80901', N'36714489702')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ab904859-a34b-4e37-a639-53296b140b98', N'Ángel', N'Menendez', CAST(N'2003-09-07' AS Date), N'5171558763', N'27C89018-0534-480C-B719-5498EEE22D77', N'44805', N'33192631456')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ab972de6-4238-4dff-9682-d04358066082', N'Vicenta', N'Martin', CAST(N'2002-05-18' AS Date), N'0210495061', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'51400', N'35184929542')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'abeede01-1ead-4856-8dbc-e58dfc320865', N'Froilana', N'Rodriguez', CAST(N'2017-04-04' AS Date), N'2902841372', N'5526D776-861B-4085-9B5F-91D58221D161', N'63859', N'33910385379')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ac5c86de-5dad-4358-a6f5-868e3ce30820', N'Concepción', N'Gil', CAST(N'2007-11-16' AS Date), N'8710898510', N'5526D776-861B-4085-9B5F-91D58221D161', N'27412', N'30651198138')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'acb925d6-3736-42c6-918b-a196ad0eda05', N'Beltran', N'Mendez', CAST(N'2016-03-16' AS Date), N'5372690625', N'27C89018-0534-480C-B719-5498EEE22D77', N'52087', N'37055013737')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ace2c190-a545-4aaa-8285-c08c7f27a36a', N'Samuel', N'Nunez', CAST(N'2009-02-24' AS Date), N'7981173197', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'22368', N'33531822418')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ad04fede-d56d-46b0-8258-00de0e742f8d', N'Rodolfa', N'Pascual', CAST(N'2011-08-07' AS Date), N'7201504935', N'5526D776-861B-4085-9B5F-91D58221D161', N'21730', N'38469619610')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ad264fd5-8cc8-4c5c-b02e-0256c746c1c4', N'Raquel', N'Medina', CAST(N'2020-09-18' AS Date), N'2586877217', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'09848', N'33320224762')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ad28e04c-446f-494c-962c-8d6ad7dca500', N'Óscar', N'Menendez', CAST(N'2003-05-21' AS Date), N'3568072921', N'5526D776-861B-4085-9B5F-91D58221D161', N'51905', N'35666251984')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ad340c7f-02e0-42bf-8ac0-decf87db0315', N'Belén', N'Soto', CAST(N'2008-02-05' AS Date), N'5054885866', N'5526D776-861B-4085-9B5F-91D58221D161', N'20398', N'39158793381')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ad4fb5b5-7328-4eba-804d-21c43a7d26f4', N'Domingo', N'Vazquez', CAST(N'2014-02-18' AS Date), N'9153663814', N'27C89018-0534-480C-B719-5498EEE22D77', N'12521', N'31514301445')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'adaca781-30d2-4f1c-b7f5-575c9bce5751', N'Tomas', N'Guerrero', CAST(N'2019-03-31' AS Date), N'4028954658', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'71600', N'33972553861')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'adbfbae8-bc9e-406e-912a-41121efe8594', N'Paulina', N'Caballero', CAST(N'2012-01-28' AS Date), N'0172241263', N'27C89018-0534-480C-B719-5498EEE22D77', N'53449', N'32764842165')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ae2dd4ad-7bbb-4b3f-9b17-39d9f8100b22', N'Ana María', N'Gonzalez', CAST(N'2008-02-10' AS Date), N'0235955662', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'40286', N'38429160560')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ae356477-c61a-4287-9b3b-061dcc17a83e', N'Frida', N'Ibanez', CAST(N'2018-10-26' AS Date), N'5627731601', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'15755', N'39740470211')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ae36c184-c109-47af-ac1c-1df453f36e94', N'Tania', N'Garcia', CAST(N'2019-09-01' AS Date), N'5267532611', N'5526D776-861B-4085-9B5F-91D58221D161', N'45049', N'36120778224')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ae48d4b1-8fce-4df1-8a7b-fc117e0d3095', N'Montenegro', N'Saez', CAST(N'2018-01-06' AS Date), N'0767335209', N'27C89018-0534-480C-B719-5498EEE22D77', N'46810', N'35601975140')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'aea99053-da95-48d1-bd3b-8979031663ab', N'Frida', N'Soler', CAST(N'2014-03-25' AS Date), N'9115967305', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'42392', N'32330549691')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'aeb8b296-8570-4a26-9eb6-d3b734c6bf35', N'Cruz', N'Herrera', CAST(N'2003-02-26' AS Date), N'0895610572', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'59390', N'30861239256')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'aed5caef-0212-4291-a532-876076be27af', N'Luis', N'Flores', CAST(N'2019-05-13' AS Date), N'0612487508', N'27C89018-0534-480C-B719-5498EEE22D77', N'09799', N'33281738453')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'aeff83d1-b7eb-4ead-8e17-0607c2fcf410', N'Dolores', N'Lorenzo', CAST(N'2020-09-07' AS Date), N'1210459082', N'27C89018-0534-480C-B719-5498EEE22D77', N'20144', N'39492364231')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'af0f6bb6-b0e3-4154-979b-7eab9a44dd05', N'Antonio', N'Vazquez', CAST(N'2004-08-27' AS Date), N'6256094305', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'41438', N'36950581309')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'af13fbe1-b132-4bf6-8f6c-cd6b035b71ae', N'Fran', N'Martin', CAST(N'2010-07-15' AS Date), N'6653524545', N'27C89018-0534-480C-B719-5498EEE22D77', N'46108', N'34453312811')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'af1910db-092c-4447-9cbd-5005a68170de', N'Montel', N'Cruz', CAST(N'2006-07-01' AS Date), N'6626943478', N'27C89018-0534-480C-B719-5498EEE22D77', N'62931', N'38703564727')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'af3849c7-5f3e-4f5f-bf44-248389f151bd', N'Nicolas', N'Romero', CAST(N'2017-07-16' AS Date), N'1404191793', N'27C89018-0534-480C-B719-5498EEE22D77', N'20848', N'33386848811')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'af3f8a0a-7073-4d24-a1a1-e83386d85341', N'Juan Sebastián', N'Sanchez', CAST(N'2016-03-13' AS Date), N'6476506452', N'27C89018-0534-480C-B719-5498EEE22D77', N'33929', N'30971020830')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'af4303ca-2f6f-48f2-bc96-fb2b32146237', N'Jacobo', N'Molina', CAST(N'2018-07-13' AS Date), N'4737643879', N'27C89018-0534-480C-B719-5498EEE22D77', N'38259', N'35755600856')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'af48461b-38a6-4b23-b422-b384d86d28a8', N'Narcisa', N'Rubio', CAST(N'2008-05-21' AS Date), N'6858770569', N'5526D776-861B-4085-9B5F-91D58221D161', N'85019', N'34137690149')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'af49534b-d008-4f00-a416-b741f606ba5d', N'Serafina', N'Mendez', CAST(N'2011-08-21' AS Date), N'8832045282', N'5526D776-861B-4085-9B5F-91D58221D161', N'53133', N'36702143230')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'af5bddee-d3b8-4f7c-9a81-bccd3b487bbc', N'Lea', N'Martinez', CAST(N'2000-06-12' AS Date), N'1258575311', N'5526D776-861B-4085-9B5F-91D58221D161', N'74289', N'33194618179')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'af6208a1-7414-4b08-bc67-e222a17923b9', N'Eufemia', N'Soler', CAST(N'2015-06-06' AS Date), N'1541552912', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'94374', N'33967561951')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'af62b13a-2f06-46aa-8487-22b47cebe111', N'Matías', N'Perez', CAST(N'2021-10-13' AS Date), N'4181996771', N'5526D776-861B-4085-9B5F-91D58221D161', N'79206', N'31408066954')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'afa265ee-e616-461a-8fc2-331bd68c1c3c', N'Malvolio', N'Moreno', CAST(N'2002-04-11' AS Date), N'2852346175', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'24964', N'35356783050')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'afb5a5c6-5ff9-476c-aa5f-238d91ae3e93', N'Azucena', N'Martinez', CAST(N'2013-09-29' AS Date), N'1459580073', N'5526D776-861B-4085-9B5F-91D58221D161', N'81284', N'39502480175')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'afd0aee6-f441-4365-a05a-08a91eab49f4', N'Tamara', N'Ortiz', CAST(N'2013-03-08' AS Date), N'4371512028', N'27C89018-0534-480C-B719-5498EEE22D77', N'43727', N'32839615501')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'afdb5739-519c-4ce0-b115-3baf1842dab5', N'Ana', N'Gutierrez', CAST(N'2015-04-20' AS Date), N'3110463630', N'5526D776-861B-4085-9B5F-91D58221D161', N'21502', N'35156239277')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b0164cf3-c4fc-4bbf-8a3d-31022a749878', N'Xavion', N'Montero', CAST(N'2008-12-03' AS Date), N'8080506653', N'27C89018-0534-480C-B719-5498EEE22D77', N'46151', N'35417249387')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b0235dab-4559-47eb-bd92-1887069abb19', N'Cobura', N'Vila', CAST(N'2010-05-30' AS Date), N'3924131110', N'5526D776-861B-4085-9B5F-91D58221D161', N'54607', N'32808062295')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b02a473f-9c6e-4725-86ab-9a31802e24e7', N'Ignado', N'Delgado', CAST(N'2009-09-22' AS Date), N'6159258667', N'27C89018-0534-480C-B719-5498EEE22D77', N'84837', N'34484470667')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b02ce188-e9f8-4802-8fbb-9fbfe2306996', N'Gervasio', N'Martinez', CAST(N'2006-08-01' AS Date), N'3030443199', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'47284', N'36013878323')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b02f6a5f-9f45-491d-a46f-197fa7e29efa', N'Macario', N'Caballero', CAST(N'2008-07-10' AS Date), N'6650132548', N'5526D776-861B-4085-9B5F-91D58221D161', N'15254', N'32514124529')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b04a62b2-12b8-4d7f-8929-191f49b1666e', N'Dylan', N'Nieto', CAST(N'2000-10-30' AS Date), N'7097400420', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'32543', N'38725058208')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b0d21ba6-ddfe-4bb8-85a5-639ee658a7c2', N'Juan Esteban', N'Caballero', CAST(N'2003-03-30' AS Date), N'3707778932', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'10371', N'39740948782')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b10ed5bb-a816-4efc-9fac-e12017cff111', N'Bautista', N'Vicente', CAST(N'2003-06-03' AS Date), N'6368989903', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'29949', N'34990649509')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b17ca6e0-fe8a-49b1-8339-a716cb3dac54', N'Desiderio', N'Munoz', CAST(N'2002-01-25' AS Date), N'6310687429', N'27C89018-0534-480C-B719-5498EEE22D77', N'21222', N'37111003101')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b18db52e-e0e5-438c-8f01-211269d45b0d', N'Meagens', N'Ramirez', CAST(N'2012-09-27' AS Date), N'0681002317', N'5526D776-861B-4085-9B5F-91D58221D161', N'40904', N'36540811718')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b1aafec9-c4b8-47b2-ae65-9fe8b8ac68dc', N'Leticia', N'Lozano', CAST(N'2015-03-11' AS Date), N'8001157944', N'27C89018-0534-480C-B719-5498EEE22D77', N'41699', N'38431653073')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b1b57a83-394a-4c74-9c44-59bfe1e9c480', N'Irati', N'Pena', CAST(N'2018-03-01' AS Date), N'5050038906', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'19790', N'30383098047')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b1b91e04-e66f-4db1-bef2-8354de7deed9', N'Selena', N'Diez', CAST(N'2019-04-30' AS Date), N'8052741832', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'18591', N'35144394195')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b1d73edc-b149-4c2c-bbb2-1ca1639a9c33', N'Gabriel', N'Castillo', CAST(N'2010-01-17' AS Date), N'8229289951', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'18963', N'32748727709')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b201c097-b56a-42ca-9039-9f6d0386f9e6', N'Carmen', N'Menendez', CAST(N'2003-07-10' AS Date), N'8483426020', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'02585', N'32910899568')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b20223cc-1bdf-41e6-b97a-30078f51261c', N'Juana', N'Iglesias', CAST(N'2016-01-13' AS Date), N'4193771840', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'81688', N'30528405015')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b23bcf72-04b6-4265-a904-e4677d5ec321', N'Marcelina', N'Herrero', CAST(N'2007-10-17' AS Date), N'0407939431', N'27C89018-0534-480C-B719-5498EEE22D77', N'61201', N'36910298147')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b2a90780-bcbe-4826-884e-a8456f37cb64', N'Paulina', N'Blanco', CAST(N'2019-12-04' AS Date), N'5070906839', N'27C89018-0534-480C-B719-5498EEE22D77', N'13731', N'38162326463')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b2c9d606-9005-4783-97a5-8584966bf35d', N'Begoña', N'Alvarez', CAST(N'2019-11-30' AS Date), N'7118457048', N'27C89018-0534-480C-B719-5498EEE22D77', N'39056', N'30221239182')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b33606e1-aa34-484c-b986-cb47d3066236', N'Simón', N'Prieto', CAST(N'2019-06-06' AS Date), N'8525785190', N'27C89018-0534-480C-B719-5498EEE22D77', N'75358', N'33300561942')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b3424874-383f-4fd4-b415-bf3fc99477bf', N'Ander', N'Campos', CAST(N'2007-04-18' AS Date), N'4356099660', N'5526D776-861B-4085-9B5F-91D58221D161', N'31137', N'36683161148')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b3b331f3-b609-4ba1-b18c-5789edb1ee71', N'christian', N'Menendez', CAST(N'2015-01-29' AS Date), N'5994349270', N'5526D776-861B-4085-9B5F-91D58221D161', N'02039', N'39478988129')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b3c95cb4-b45f-4f41-b84a-d8e4fc0d07b7', N'Alondra', N'Bravo', CAST(N'2017-05-09' AS Date), N'4375727939', N'27C89018-0534-480C-B719-5498EEE22D77', N'56703', N'36923556583')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b3ea1325-ad03-4fa1-bbd1-07c5453ac33f', N'Sofía', N'Blanco', CAST(N'2021-02-04' AS Date), N'2961347790', N'5526D776-861B-4085-9B5F-91D58221D161', N'48924', N'32754220307')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b3f353d1-2305-4049-b84d-d527f19675b9', N'Elena', N'Crespo', CAST(N'2018-04-25' AS Date), N'6439740755', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'08170', N'35934151763')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b48f55ca-8e16-4910-a97f-3bd1f55ad85e', N'Fatima', N'Ramos', CAST(N'2018-04-15' AS Date), N'1232810726', N'5526D776-861B-4085-9B5F-91D58221D161', N'39305', N'33288701199')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b4ad6d0d-bd7f-4702-946c-dfff603bd28e', N'Martín', N'Ortega', CAST(N'2011-11-24' AS Date), N'9407485685', N'5526D776-861B-4085-9B5F-91D58221D161', N'59274', N'36948857761')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b516ac55-8798-4a14-85eb-8bbd2d751a64', N'Marc', N'Rey', CAST(N'2021-02-24' AS Date), N'0563571098', N'5526D776-861B-4085-9B5F-91D58221D161', N'21660', N'32958472647')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b534bb6b-597b-4fc4-8598-3f52f3e96b7f', N'Pàola', N'Aguilar', CAST(N'2002-08-22' AS Date), N'7971561205', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'75224', N'38153964139')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b5587019-0f85-4c0f-b446-ae00628d7da4', N'Carla', N'Vidal', CAST(N'2020-06-18' AS Date), N'8313443583', N'5526D776-861B-4085-9B5F-91D58221D161', N'66942', N'34450028313')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b5675f1c-5004-4e70-a7f2-bd9bace0e937', N'Jacqueline', N'Campos', CAST(N'2007-01-19' AS Date), N'0475259067', N'5526D776-861B-4085-9B5F-91D58221D161', N'75501', N'32010309485')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b5ad574e-a6ee-485f-aa4e-fc862c255114', N'Paulina', N'Arias', CAST(N'2019-01-18' AS Date), N'9376678536', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'01918', N'32428317798')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b5bcac3e-ac50-4dc4-be8f-582111557a92', N'Mateo', N'Saez', CAST(N'2004-08-26' AS Date), N'6627562883', N'5526D776-861B-4085-9B5F-91D58221D161', N'49976', N'30222943081')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b5cbdc53-3b34-40d6-9532-5b1aef6fba43', N'Óscar', N'Lopez', CAST(N'2001-03-18' AS Date), N'9911248429', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'50835', N'39812957945')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b5d0d88a-db44-4694-9ab3-e774fc3d1587', N'Miguel Ángel', N'Marquez', CAST(N'2006-02-24' AS Date), N'2303713914', N'5526D776-861B-4085-9B5F-91D58221D161', N'95865', N'35290748216')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b5ddeb95-ce2f-4214-a02b-17b31398429f', N'Cándida', N'Duran', CAST(N'2009-01-24' AS Date), N'6760930191', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'57328', N'35567445253')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b5f909d4-07f9-4d8b-9b58-656e3e5d3c57', N'Martita', N'Martinez', CAST(N'2012-07-09' AS Date), N'5090443515', N'5526D776-861B-4085-9B5F-91D58221D161', N'91427', N'39455494361')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b615786e-3648-4cd8-a57f-67035252745b', N'Jaime', N'Crespo', CAST(N'2010-12-18' AS Date), N'3446517393', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'32910', N'39699807350')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b640d09d-1246-478e-8336-a49bded351e8', N'Fraco', N'Castro', CAST(N'2005-02-21' AS Date), N'4748902475', N'27C89018-0534-480C-B719-5498EEE22D77', N'59991', N'37694565884')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b6485cd8-1c2b-4989-927e-45176b7c9d79', N'Adisoda', N'Soto', CAST(N'2017-01-27' AS Date), N'5810078342', N'5526D776-861B-4085-9B5F-91D58221D161', N'39752', N'30786678216')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b6e1e5a9-bac1-47dc-b108-582dde3b3565', N'Marjun', N'Moya', CAST(N'2006-07-01' AS Date), N'5942990254', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'63911', N'37708891071')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b6eb7ac4-6705-42aa-be6a-cc7cd8ba92e4', N'Axel', N'Saez', CAST(N'2019-04-24' AS Date), N'2492497348', N'27C89018-0534-480C-B719-5498EEE22D77', N'35679', N'37265073067')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b753f2a6-cf03-4f02-8672-a6a3ecea1538', N'Larenzo', N'Reyes', CAST(N'2009-03-25' AS Date), N'2036188687', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'35241', N'36648175869')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b761b9ac-ec71-4f91-b094-c9be398f00bf', N'Asier', N'Diaz', CAST(N'2004-02-03' AS Date), N'1952745590', N'5526D776-861B-4085-9B5F-91D58221D161', N'26020', N'39083409568')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b7932d65-4426-4166-b768-360aac5802f1', N'Begoña', N'Fuentes', CAST(N'2012-01-05' AS Date), N'2045592814', N'5526D776-861B-4085-9B5F-91D58221D161', N'34709', N'30381564442')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b7b2e95e-510e-4f70-a6b6-47b25d95fc60', N'Frisco', N'Cano', CAST(N'2010-07-05' AS Date), N'1276177723', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'69986', N'35466409551')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b7bd50cf-2a25-465d-8177-749532ba6415', N'Elena', N'Vazquez', CAST(N'2002-01-25' AS Date), N'1131296237', N'5526D776-861B-4085-9B5F-91D58221D161', N'74575', N'34592833929')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b7cb41fa-49f3-4b0d-9183-09ffa3b6a6f3', N'Dario', N'Alonso', CAST(N'2012-06-26' AS Date), N'0930067485', N'27C89018-0534-480C-B719-5498EEE22D77', N'50466', N'39711908748')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b7d393d8-3d24-40c6-ab9d-1c9f03a7b3a1', N'Yesenia', N'Garrido', CAST(N'2001-03-13' AS Date), N'1186945230', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'15908', N'35453485189')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b7db486e-2289-49fe-8fff-3cbecb8148c3', N'Adrián', N'Romero', CAST(N'2021-07-30' AS Date), N'8503340580', N'5526D776-861B-4085-9B5F-91D58221D161', N'47113', N'37475713378')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b81cb6d8-5577-405e-9f08-610b175ab1e1', N'Úrsula', N'Cabrera', CAST(N'2019-07-30' AS Date), N'2552428521', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'57620', N'32932370952')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b85b7566-60aa-423f-85ad-4b24521cd871', N'Mauricio', N'Ruiz', CAST(N'2002-01-26' AS Date), N'5139873794', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'07336', N'36358659067')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b863ece8-c38a-4b24-9af1-3cbae9549fc0', N'Dolores', N'Vicente', CAST(N'2014-03-12' AS Date), N'0239381474', N'27C89018-0534-480C-B719-5498EEE22D77', N'26000', N'37164892840')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b86f3c90-8282-4817-afb9-56f0c3532878', N'Lilia', N'Gomez', CAST(N'2006-11-26' AS Date), N'8836087733', N'5526D776-861B-4085-9B5F-91D58221D161', N'63564', N'33933585184')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b8b7d01c-f03c-4b76-8d09-9e87c0a8c780', N'Jose miguel', N'Flores', CAST(N'2005-09-20' AS Date), N'9464926576', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'82021', N'33433223617')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b8c37a0c-9f19-4b83-9e5e-7c21613e5aa5', N'Valentino', N'Flores', CAST(N'2000-10-02' AS Date), N'5164720733', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'06876', N'34602548200')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b8c6bdfa-3c89-46f8-b99b-ac37ac669ad0', N'Alicia', N'Cano', CAST(N'2018-11-23' AS Date), N'4186690054', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'51544', N'33854802822')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b8cf1b35-d926-4516-9ce4-84acaae9cda9', N'Agustín', N'Alvarez', CAST(N'2006-11-12' AS Date), N'3444792166', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'42081', N'35886092083')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b8fe3890-ed6a-480a-8cfc-d79b1363cece', N'Adelaida', N'Jimenez', CAST(N'2009-03-07' AS Date), N'6094372272', N'27C89018-0534-480C-B719-5498EEE22D77', N'39295', N'37995724702')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b9431f2e-c256-45d2-9d29-c5350882cfca', N'Luis', N'Fernandez', CAST(N'2016-01-01' AS Date), N'7207224361', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'58652', N'36790153068')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b946c9ad-d4ce-47a3-9dce-70faf2e44dc2', N'Yesenia', N'Pena', CAST(N'2011-07-22' AS Date), N'3774558422', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'25428', N'30822283256')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b989481e-2a4b-4a62-b97b-d0d7d9ffed99', N'Jerónimo/Gerónimo', N'Ibanez', CAST(N'2011-11-14' AS Date), N'9739461820', N'27C89018-0534-480C-B719-5498EEE22D77', N'45521', N'31997812909')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'b9e08771-9f8d-4427-804e-69f8e2750e34', N'Virginia', N'Perez', CAST(N'2008-01-05' AS Date), N'7218808511', N'27C89018-0534-480C-B719-5498EEE22D77', N'29713', N'30612772881')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ba0d9858-6470-494d-bb67-be999edb1488', N'Dylan', N'Ortega', CAST(N'2012-07-21' AS Date), N'1010158337', N'5526D776-861B-4085-9B5F-91D58221D161', N'89575', N'36877380038')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ba1b7cd4-f2f1-4ccb-90d7-0f1e2e5fa196', N'dani', N'Roman', CAST(N'2006-05-04' AS Date), N'7414909002', N'5526D776-861B-4085-9B5F-91D58221D161', N'79880', N'37297939152')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ba244473-cd82-4b78-9720-701fccbdb8fa', N'Ian', N'Medina', CAST(N'2021-07-19' AS Date), N'7674923225', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'72192', N'38876025545')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ba58b62a-11e1-4d92-9743-9206972af9ce', N'dani', N'Lopez', CAST(N'2010-06-26' AS Date), N'7090166649', N'5526D776-861B-4085-9B5F-91D58221D161', N'19931', N'30875532590')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ba827400-09b6-4330-be46-8f7877c0540e', N'Lisandro', N'Marcos', CAST(N'2021-07-01' AS Date), N'8041636688', N'5526D776-861B-4085-9B5F-91D58221D161', N'14585', N'30128432940')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ba9cfa85-86c5-47b3-a6ba-dac5bcf5dbfa', N'Manuelita', N'Menendez', CAST(N'2010-02-13' AS Date), N'2125993285', N'27C89018-0534-480C-B719-5498EEE22D77', N'87036', N'33554945134')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'bae07bfd-6eb3-422f-9d93-cb124ac241fa', N'Guido', N'Crespo', CAST(N'2006-07-21' AS Date), N'6266822515', N'27C89018-0534-480C-B719-5498EEE22D77', N'58090', N'30091179241')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'baf4e625-d40e-4d1d-aa4b-f578eae3bb95', N'Xalvador', N'Gimenez', CAST(N'2001-08-05' AS Date), N'4857423319', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'93980', N'30113294226')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'bb4018f4-2432-4764-87b4-539cfe61fa5a', N'Enrique', N'Vazquez', CAST(N'2001-10-29' AS Date), N'5400738030', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'81197', N'35628045987')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'bb6989d7-c6e5-4afa-95b4-f45d17352db9', N'Juan José', N'Pardo', CAST(N'2014-03-13' AS Date), N'9680996450', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'17666', N'35336078855')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'bbaf1a04-f01a-48dc-b5d8-9a3aa6c0da7f', N'Carlos', N'Flores', CAST(N'2011-07-30' AS Date), N'2752799537', N'5526D776-861B-4085-9B5F-91D58221D161', N'14046', N'36462343571')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'bbbd5323-8dbe-488a-993e-03b601ca01ee', N'Ángela', N'Pascual', CAST(N'2010-04-02' AS Date), N'2561166800', N'5526D776-861B-4085-9B5F-91D58221D161', N'77403', N'39500752552')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'bc2760b3-02e7-4dd2-a19c-45b86fe29c8d', N'Macario', N'Martinez', CAST(N'2011-10-26' AS Date), N'9277502797', N'5526D776-861B-4085-9B5F-91D58221D161', N'39903', N'30026386007')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'bc3c5268-78dd-4d9d-b6e8-0fd51884488d', N'Arnau', N'Guerrero', CAST(N'2007-04-12' AS Date), N'3631318215', N'5526D776-861B-4085-9B5F-91D58221D161', N'10667', N'38481774009')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'bc4c92a4-0c38-4da5-868b-5712238b7934', N'Eugenia', N'Gomez', CAST(N'2007-09-26' AS Date), N'7226969312', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'99856', N'36234315659')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'bc658e30-8b2f-4ea1-852e-f675c764bce8', N'Cobura', N'Delgado', CAST(N'2004-11-03' AS Date), N'7742421868', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'15355', N'32593489544')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'bca216c5-74c0-43b3-a82a-7c815b69f331', N'Miguel Angel', N'Vila', CAST(N'2018-11-16' AS Date), N'0239905437', N'27C89018-0534-480C-B719-5498EEE22D77', N'85368', N'33555494994')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'bcbd9884-2de7-402c-8b8a-d41fa5375021', N'Lucía', N'Gonzalez', CAST(N'2018-11-21' AS Date), N'6380972638', N'27C89018-0534-480C-B719-5498EEE22D77', N'28577', N'37351001364')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'bcda04cc-c738-43f7-b19d-07e56671cfc7', N'Diana', N'Redondo', CAST(N'2012-04-29' AS Date), N'9375944727', N'5526D776-861B-4085-9B5F-91D58221D161', N'67215', N'30373904714')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'bcda5e0c-0275-4412-9626-48c16f44fd20', N'Cipriano', N'Medina', CAST(N'2004-06-30' AS Date), N'3739753769', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'74253', N'34220824427')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'bd7537ab-a70b-4b44-b7ce-6f11eca85d73', N'Xaverius', N'Arias', CAST(N'2003-09-20' AS Date), N'4339105709', N'5526D776-861B-4085-9B5F-91D58221D161', N'31493', N'38692336079')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'bd8a63e7-a70e-4921-b93d-df2bd1c39599', N'Cobura', N'Campos', CAST(N'2021-02-22' AS Date), N'3202532302', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'53515', N'33021776548')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'bdaf74a2-09d0-4d77-8470-576e94574b2f', N'Tiare', N'Marquez', CAST(N'2021-08-26' AS Date), N'5248401110', N'5526D776-861B-4085-9B5F-91D58221D161', N'68578', N'37854094130')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'bdc672f2-d05f-465d-acef-cc1297670bb7', N'Evita', N'Roman', CAST(N'2020-11-02' AS Date), N'5467548746', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'87517', N'39558225857')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'be175af4-379c-46d7-829d-df12c73afece', N'Belén', N'Calvo', CAST(N'2019-10-13' AS Date), N'1800727102', N'27C89018-0534-480C-B719-5498EEE22D77', N'60885', N'38532465200')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'be37a90f-56fc-4062-8ad3-a49b7c50f635', N'Agapetus', N'Menendez', CAST(N'2014-11-21' AS Date), N'5091227262', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'76367', N'37655451902')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'be609b59-bb11-45f8-b2ee-63e15d556334', N'Cristóbal', N'Santos', CAST(N'2005-04-23' AS Date), N'2547815793', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'78121', N'38785965519')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'be7fd08d-a78a-4f8c-8c42-081b100929de', N'Caro', N'Vicente', CAST(N'2004-05-01' AS Date), N'0441402448', N'27C89018-0534-480C-B719-5498EEE22D77', N'10504', N'34288980935')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'be7fdfb3-631f-4f2f-985e-ee3eaa59854f', N'Soraya', N'Rodriguez', CAST(N'2000-01-09' AS Date), N'2084778652', N'27C89018-0534-480C-B719-5498EEE22D77', N'34695', N'36212897504')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'be9b70bf-127f-4f41-8ced-c7ffde481102', N'Clotilde', N'Dominguez', CAST(N'2011-01-31' AS Date), N'4663894071', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'56629', N'38069990044')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'be9e1f88-ec09-4a84-918d-5d505ec24230', N'Fernando', N'Leon', CAST(N'2017-10-10' AS Date), N'1584505192', N'27C89018-0534-480C-B719-5498EEE22D77', N'62602', N'31104579809')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'bea4dbdb-04dd-4c6e-828f-56eac33030cd', N'Felisa', N'Aguilar', CAST(N'2006-04-16' AS Date), N'9005340325', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'42338', N'35858814016')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'bebfd712-861e-455d-b3b0-cae145c12a64', N'Adisoda', N'Carmona', CAST(N'2019-05-24' AS Date), N'6154455958', N'27C89018-0534-480C-B719-5498EEE22D77', N'84157', N'39739838627')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'bec16ae3-b71c-4a52-a8f1-8b80d0c6978c', N'Xaver', N'Diaz', CAST(N'2001-03-23' AS Date), N'9556333477', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'06341', N'33690017132')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'bf0a4236-94cf-4aa3-9f9a-ef1fecb399c5', N'Lidia', N'Saez', CAST(N'2021-06-16' AS Date), N'9901463992', N'5526D776-861B-4085-9B5F-91D58221D161', N'64633', N'35491142848')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'bf2ee641-035f-4326-9df2-f41c143eb555', N'Carolina', N'Diaz', CAST(N'2017-09-15' AS Date), N'8094732352', N'5526D776-861B-4085-9B5F-91D58221D161', N'46089', N'34892126682')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'bf5926e6-0fbd-48a8-a836-1b11b80e649d', N'María Juana', N'Roman', CAST(N'2015-08-09' AS Date), N'5585610403', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'39596', N'37785225932')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'bf63bd9f-6e0e-4487-b7e4-655a79c64310', N'Diego', N'Carmona', CAST(N'2012-06-02' AS Date), N'1545679696', N'27C89018-0534-480C-B719-5498EEE22D77', N'82483', N'33760258941')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'bf882105-baeb-4f0c-8384-e180ec649205', N'Karina', N'Crespo', CAST(N'2000-02-24' AS Date), N'0840129506', N'5526D776-861B-4085-9B5F-91D58221D161', N'74945', N'32344266907')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'bfbdf423-b6fd-40db-91f1-3456ff274f18', N'Tomas', N'Nunez', CAST(N'2018-03-25' AS Date), N'4905987118', N'27C89018-0534-480C-B719-5498EEE22D77', N'05413', N'34990011744')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c0138d24-9a50-46fd-9d09-f3dd6da12250', N'Luis', N'Soler', CAST(N'2021-06-09' AS Date), N'8934717786', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'83955', N'30125485948')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c051bbdb-0b24-4be2-8ffb-960d2e83784c', N'Agustina', N'Garrido', CAST(N'2016-01-10' AS Date), N'6755720372', N'27C89018-0534-480C-B719-5498EEE22D77', N'56013', N'38119367933')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c076958d-b095-421f-a47b-7e23b129e1f4', N'Yolanda', N'Alvarez', CAST(N'2005-10-21' AS Date), N'6765572977', N'27C89018-0534-480C-B719-5498EEE22D77', N'98232', N'32859457133')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c08fe929-5f98-4f8d-88bd-bd22a4fc6c3e', N'Alex', N'Ferrer', CAST(N'2011-04-03' AS Date), N'9576382574', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'70969', N'30571352591')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c0b1ed17-b62c-4b62-b5c7-757a607f0bfd', N'Rocío', N'Cabrera', CAST(N'2011-07-28' AS Date), N'3962279408', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'14029', N'37238787329')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c0e9494c-b111-4337-a458-abeeda6fad96', N'Sergio', N'Menendez', CAST(N'2012-08-16' AS Date), N'4788468390', N'5526D776-861B-4085-9B5F-91D58221D161', N'70672', N'36280450055')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c0edeefe-d1c3-4ba2-8bc4-1d3e5e6cd8f4', N'Laia', N'Castro', CAST(N'2012-09-26' AS Date), N'3223109279', N'5526D776-861B-4085-9B5F-91D58221D161', N'21062', N'30729143423')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c12b40b0-fc06-46fe-87b5-a5c5a0b64138', N'Keiko', N'Marquez', CAST(N'2007-05-24' AS Date), N'7224282676', N'5526D776-861B-4085-9B5F-91D58221D161', N'86951', N'32687456781')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c12b5862-ad5d-4f2e-9486-32cb7f6776bd', N'Iker', N'Gil', CAST(N'2000-09-01' AS Date), N'5369185014', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'40338', N'37510881620')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c14939d2-8d85-47d8-9610-42bf27275766', N'Catrina', N'Calvo', CAST(N'2002-06-07' AS Date), N'5545270409', N'5526D776-861B-4085-9B5F-91D58221D161', N'82412', N'32460418078')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c151268c-02ed-4686-b5b0-cac7fcc356ca', N'Hernan', N'Arias', CAST(N'2001-07-23' AS Date), N'0177771593', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'93832', N'33216257716')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c15e5c6e-0775-4211-874e-bf63a7308b16', N'Vicente', N'Marcos', CAST(N'2008-03-10' AS Date), N'4249504679', N'27C89018-0534-480C-B719-5498EEE22D77', N'42195', N'32145963727')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c1720d45-ec7b-46ab-9a22-3115755ea076', N'Ricardo', N'Romero', CAST(N'2010-02-12' AS Date), N'8868251979', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'31630', N'39776030369')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c1cce9ea-aeca-448c-ac94-2239af54ac71', N'Dylan', N'Gomez', CAST(N'2000-01-26' AS Date), N'6632949744', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'88788', N'30908910133')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c1dd8324-19c7-4532-878c-ed2463495ef1', N'Bautista', N'Sanz', CAST(N'2004-03-25' AS Date), N'4191081756', N'5526D776-861B-4085-9B5F-91D58221D161', N'47756', N'39807578858')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c21ca42e-8704-47e3-8dc9-17fa646b6045', N'Ainara', N'Cano', CAST(N'2019-04-13' AS Date), N'4379032216', N'27C89018-0534-480C-B719-5498EEE22D77', N'80852', N'35499081852')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c24a6ab3-55aa-4ff1-9fd6-ea9409c6c091', N'Silvia', N'Mendez', CAST(N'2009-07-01' AS Date), N'7947674702', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'88467', N'35313053383')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c24c2f2f-4974-45f1-b62f-d1f6c2f940f5', N'Violeta', N'Ramos', CAST(N'2020-08-26' AS Date), N'5370792888', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'95253', N'37672393544')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c27249cd-d4da-4a30-b8af-07397e733ff8', N'Elías', N'Izquierdo', CAST(N'2000-11-14' AS Date), N'8781305636', N'5526D776-861B-4085-9B5F-91D58221D161', N'33638', N'32034462782')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c2954517-6f27-4952-b150-3f6be8127241', N'Noe', N'Gomez', CAST(N'2011-10-28' AS Date), N'3388116258', N'27C89018-0534-480C-B719-5498EEE22D77', N'60238', N'35207226656')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c2a9cacd-0b2a-4cb8-a382-a2425e872be0', N'Milagros', N'Dominguez', CAST(N'2020-09-07' AS Date), N'9996274216', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'30005', N'38105789857')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c2dbe140-1487-43da-8292-7a8d52cf775c', N'Cruz', N'Fuentes', CAST(N'2007-02-14' AS Date), N'9199138019', N'5526D776-861B-4085-9B5F-91D58221D161', N'22237', N'30723840631')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c2e1f56b-a7a5-4b1c-ba99-926b9c2278a9', N'Macario', N'Santos', CAST(N'2016-05-11' AS Date), N'1008599370', N'27C89018-0534-480C-B719-5498EEE22D77', N'88332', N'37040584644')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c32ffad2-cf72-40b1-892b-d140c5059ed2', N'Feliciana', N'Roman', CAST(N'2013-10-10' AS Date), N'9327064567', N'5526D776-861B-4085-9B5F-91D58221D161', N'22874', N'32789387065')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c349c0d2-60ee-4ab4-a5db-ebd825358bd6', N'Tomasa', N'Rodriguez', CAST(N'2004-02-04' AS Date), N'6915941238', N'27C89018-0534-480C-B719-5498EEE22D77', N'60015', N'39324182017')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c35e4d0e-99cf-4649-8ef5-5b49d1c1e299', N'Rocío', N'Saez', CAST(N'2011-02-10' AS Date), N'2104601525', N'27C89018-0534-480C-B719-5498EEE22D77', N'52056', N'32137275927')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c3d73001-e737-4109-9f4a-9fdf6c2f2217', N'Juan Pablo', N'Blanco', CAST(N'2009-04-13' AS Date), N'9920739463', N'27C89018-0534-480C-B719-5498EEE22D77', N'10186', N'30033465997')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c3dccfb6-1f3c-49d4-bde8-1d5f5ea4164d', N'Fátima', N'Torres', CAST(N'2019-08-23' AS Date), N'2903391229', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'76015', N'37309814520')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c3dd3012-6200-492f-869d-fb69bf974b77', N'Valentino', N'Molina', CAST(N'2000-09-26' AS Date), N'2245374074', N'5526D776-861B-4085-9B5F-91D58221D161', N'13398', N'31530405168')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c3e29fe1-fe08-49cc-8580-a48f447e6bcb', N'Manuelita', N'Ruiz', CAST(N'2011-09-16' AS Date), N'5983856413', N'5526D776-861B-4085-9B5F-91D58221D161', N'73665', N'31941579407')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c4493bcd-c160-44a0-9508-3862b92280c2', N'Bronco', N'Reyes', CAST(N'2017-10-01' AS Date), N'3431886669', N'27C89018-0534-480C-B719-5498EEE22D77', N'42262', N'36304181931')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c466afdc-6196-4fc7-bbde-6a8386bd096b', N'Hilda', N'Castillo', CAST(N'2021-03-08' AS Date), N'9754411362', N'5526D776-861B-4085-9B5F-91D58221D161', N'28993', N'39752452671')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c4a26f81-53ba-4fed-9369-280cfec7cb9d', N'Julen', N'Morales', CAST(N'2015-01-02' AS Date), N'0479305051', N'5526D776-861B-4085-9B5F-91D58221D161', N'87886', N'30933389763')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c4b0efd4-fc18-4cb8-83c5-7e877b5d90a8', N'Domingo', N'Gutierrez', CAST(N'2011-11-26' AS Date), N'5227098679', N'27C89018-0534-480C-B719-5498EEE22D77', N'82148', N'39917863378')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c4c0f83f-ccfc-48c9-98d5-401807091571', N'Jesús', N'Fernandez', CAST(N'2021-05-06' AS Date), N'0000888678', N'5526D776-861B-4085-9B5F-91D58221D161', N'84917', N'31808928947')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c4c7dba0-0d81-41a8-851d-5665cbf86fdd', N'Fraco', N'Velasco', CAST(N'2018-12-19' AS Date), N'6215218293', N'27C89018-0534-480C-B719-5498EEE22D77', N'99907', N'38771498385')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c50f9185-3c54-4156-ae64-057087c7cc01', N'Álvaro', N'Suarez', CAST(N'2014-09-07' AS Date), N'0237783849', N'27C89018-0534-480C-B719-5498EEE22D77', N'36682', N'34713817915')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c51ba658-9765-4534-b70d-6c1aa63ef6c3', N'Julieta', N'Ramos', CAST(N'2014-06-07' AS Date), N'7903309582', N'5526D776-861B-4085-9B5F-91D58221D161', N'84035', N'35110451187')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c51f76f9-737e-4d1e-85e9-309711feef74', N'Aimon', N'Martin', CAST(N'2014-11-09' AS Date), N'8905607836', N'27C89018-0534-480C-B719-5498EEE22D77', N'39511', N'37605940612')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c571885d-5425-4895-ab8f-241f3a22e186', N'Judit', N'Perez', CAST(N'2000-03-23' AS Date), N'5564877353', N'27C89018-0534-480C-B719-5498EEE22D77', N'17120', N'39570716695')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c59a7ddb-c16c-45c9-83d4-a35726e833a6', N'Silvia', N'Sanchez', CAST(N'2004-03-09' AS Date), N'3201000771', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'45140', N'39460414371')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c5d4570c-1340-465f-bfc7-564890940828', N'Gervasio', N'Santos', CAST(N'2017-05-02' AS Date), N'5182781656', N'5526D776-861B-4085-9B5F-91D58221D161', N'00947', N'32603518169')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c5d8414d-744b-493d-97f1-942f8791dc0b', N'Carmen', N'Bravo', CAST(N'2020-11-16' AS Date), N'2863035151', N'27C89018-0534-480C-B719-5498EEE22D77', N'40323', N'34383556671')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c5f3586b-ac18-4dde-987d-7268ee2cbf3e', N'Aida', N'Lorenzo', CAST(N'2010-02-21' AS Date), N'5703942149', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'81189', N'31594651213')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c6078907-c746-421d-b6bc-c83e8b879e38', N'Dario', N'Gimenez', CAST(N'2004-02-10' AS Date), N'6734073010', N'5526D776-861B-4085-9B5F-91D58221D161', N'91820', N'36480301630')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c63893df-dbbd-4228-b67c-99b0459afff8', N'Antonio', N'Soto', CAST(N'2019-11-05' AS Date), N'6618379841', N'5526D776-861B-4085-9B5F-91D58221D161', N'38721', N'39816760350')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c63dc668-9bcc-4cde-a78f-d46c675f6d3a', N'Dylan', N'Rubio', CAST(N'2006-04-02' AS Date), N'2244279933', N'27C89018-0534-480C-B719-5498EEE22D77', N'30061', N'39748013030')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c66dba4e-311e-4212-8701-9e3b0303f263', N'Leticia', N'Merino', CAST(N'2020-05-14' AS Date), N'5500609119', N'27C89018-0534-480C-B719-5498EEE22D77', N'53685', N'30295632432')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c66f149e-49eb-44cc-a76f-a0eb6c762243', N'Juan David', N'Lopez', CAST(N'2018-03-16' AS Date), N'4083070165', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'94115', N'34350262855')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c68f51bc-6326-48f4-9b2a-ae3ae2a26887', N'Ramira', N'Redondo', CAST(N'2002-12-27' AS Date), N'0737896261', N'5526D776-861B-4085-9B5F-91D58221D161', N'20724', N'34401383267')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c69e9cf3-4e87-4d39-9064-03db273643b8', N'Xaver', N'Arias', CAST(N'2015-02-15' AS Date), N'8981477898', N'5526D776-861B-4085-9B5F-91D58221D161', N'92971', N'35593800119')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c6a2212a-87c7-4351-b0c4-1ad43c622b42', N'Joaquín', N'Izquierdo', CAST(N'2004-05-02' AS Date), N'2274528908', N'27C89018-0534-480C-B719-5498EEE22D77', N'11834', N'34240756355')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c6e608a7-3076-443b-9f62-7f264a6c37a4', N'Filomena', N'Nieto', CAST(N'2015-08-27' AS Date), N'2537485306', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'73728', N'35081162741')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c6e8b811-e35b-4c85-932c-d49c295d39bc', N'Montana', N'Marcos', CAST(N'2002-01-11' AS Date), N'8262969110', N'27C89018-0534-480C-B719-5498EEE22D77', N'02439', N'36274825143')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c6f243c1-37df-4f33-ab82-9888f3d707cc', N'Fulberta', N'Menendez', CAST(N'2011-06-20' AS Date), N'6810168821', N'5526D776-861B-4085-9B5F-91D58221D161', N'61625', N'38270325782')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c7445e9e-9db1-4162-9095-d8c2a4781030', N'Álvaro', N'Moreno', CAST(N'2019-11-16' AS Date), N'0981703224', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'24005', N'30118144419')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c746caf6-5fd9-4490-bbef-b445cdde0313', N'Máximo', N'Vila', CAST(N'2009-12-05' AS Date), N'3875402374', N'5526D776-861B-4085-9B5F-91D58221D161', N'88139', N'36639735536')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c7596ccc-a66c-4f18-a7ec-9a0dc52aecbd', N'Hugo', N'Hernandez', CAST(N'2008-08-11' AS Date), N'3141733438', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'96733', N'39894466423')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c75c00af-a4d9-4271-8aff-33d6f99353d9', N'Jerónimo/Gerónimo', N'Marquez', CAST(N'2013-09-05' AS Date), N'6937131352', N'5526D776-861B-4085-9B5F-91D58221D161', N'92022', N'39679699674')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c76b3a30-fb61-4d90-8961-79ed5fe61ade', N'Encarnación', N'Martin', CAST(N'2003-08-25' AS Date), N'9710760258', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'14864', N'33073098122')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c771a540-198e-476d-bfd9-e783cec4ff2d', N'Alicia', N'Moreno', CAST(N'2000-01-25' AS Date), N'5862997241', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'18119', N'32461284385')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c782f9b5-77be-426d-a1a7-19d533d76ff5', N'Belen', N'Hidalgo', CAST(N'2008-10-20' AS Date), N'2768753748', N'5526D776-861B-4085-9B5F-91D58221D161', N'17569', N'33145597152')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c784b93b-df5b-4a82-bbab-81e04cd584d6', N'Alejandra', N'Moreno', CAST(N'2012-02-21' AS Date), N'1954455881', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'36840', N'38753131614')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c7e50fc3-98f9-4ac3-b672-7496cd4cce56', N'Bronco', N'Herrero', CAST(N'2006-01-13' AS Date), N'8847307878', N'5526D776-861B-4085-9B5F-91D58221D161', N'53894', N'38977705630')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c7e6c2c7-16bd-4139-b04a-357044aa717f', N'Enriqueta', N'Nunez', CAST(N'2013-09-03' AS Date), N'2497052890', N'5526D776-861B-4085-9B5F-91D58221D161', N'53746', N'39893822085')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c7faaa12-16d5-4dd1-b8f9-b1e12512ddd0', N'Aina', N'Fernandez', CAST(N'2018-11-16' AS Date), N'7057130742', N'27C89018-0534-480C-B719-5498EEE22D77', N'47331', N'35440297345')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c80607a8-558e-43e2-990c-d8b4599abb87', N'Jacobo', N'Munoz', CAST(N'2019-02-05' AS Date), N'5002379586', N'27C89018-0534-480C-B719-5498EEE22D77', N'68568', N'33101641171')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c8129e43-59a7-4472-b31b-fe0dbddfbea4', N'Carla', N'Gutierrez', CAST(N'2020-07-21' AS Date), N'6061006813', N'5526D776-861B-4085-9B5F-91D58221D161', N'76126', N'39705631852')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c821a9a8-5f43-4378-bd71-2bf88d075a98', N'Isaac', N'Cano', CAST(N'2018-07-06' AS Date), N'9652798037', N'5526D776-861B-4085-9B5F-91D58221D161', N'43965', N'37816436356')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c83d3359-8478-4d91-898a-d5834bb533b5', N'Nicolas', N'Fernandez', CAST(N'2011-09-30' AS Date), N'6746667686', N'27C89018-0534-480C-B719-5498EEE22D77', N'76052', N'30981256580')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c85c94dd-05c1-44ec-904e-6c524d019d6a', N'Rosalía', N'Martinez', CAST(N'2000-02-24' AS Date), N'7428517329', N'5526D776-861B-4085-9B5F-91D58221D161', N'88398', N'30710246410')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c85eb3b0-c326-4c5a-9f03-844cb4e2cd5f', N'Mirella', N'Pena', CAST(N'2013-07-31' AS Date), N'5325611556', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'56750', N'33292372083')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c88c4dc7-225f-412c-9e86-864368a8335b', N'Lorenzo', N'Alvarez', CAST(N'2012-10-12' AS Date), N'2578147895', N'5526D776-861B-4085-9B5F-91D58221D161', N'53919', N'39945103294')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c94d4d2c-2118-44a2-a78b-6177101e98b8', N'Cipriano', N'Castro', CAST(N'2000-03-09' AS Date), N'5005983973', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'42704', N'39916881039')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c95775f4-d7ea-4198-954c-2bdf632a3ce5', N'Miguel Ángel', N'Garrido', CAST(N'2007-02-03' AS Date), N'2876056446', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'50200', N'33319874226')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c9a74780-d5ea-41af-9f53-d412787ac585', N'Matías', N'Vega', CAST(N'2019-11-08' AS Date), N'0624272340', N'5526D776-861B-4085-9B5F-91D58221D161', N'59393', N'36958232530')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c9d8f4c3-6435-440d-b6cf-4b3f75b95e9f', N'Camilo', N'Calvo', CAST(N'2003-05-04' AS Date), N'3621071650', N'27C89018-0534-480C-B719-5498EEE22D77', N'96275', N'39234994828')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'c9dbc3aa-f434-4ee4-a4d3-67c8f0d256ab', N'Ignacio', N'Gomez', CAST(N'2013-01-09' AS Date), N'4909923970', N'27C89018-0534-480C-B719-5498EEE22D77', N'83234', N'39208788892')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ca1d3e48-22cc-42f2-947f-12d8996b0d7b', N'Jaime', N'Gomez', CAST(N'2003-02-14' AS Date), N'0568988986', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'49042', N'30625474423')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ca67b9bb-4426-454d-8ca9-d929056644a2', N'Vane', N'Montero', CAST(N'2004-06-27' AS Date), N'8056736280', N'5526D776-861B-4085-9B5F-91D58221D161', N'81120', N'35489004389')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ca686907-24ba-4613-824a-2d01fb98cfd3', N'Adisoda', N'Medina', CAST(N'2015-01-23' AS Date), N'6432139085', N'5526D776-861B-4085-9B5F-91D58221D161', N'33736', N'38149376572')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'cac3b2e0-2780-4bcd-8ebc-1784750b0bcc', N'Ivan', N'Campos', CAST(N'2004-11-10' AS Date), N'9185213662', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'98021', N'39634777670')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'cad81f7a-b349-4a13-947f-897b2645d85b', N'Valentina', N'Santos', CAST(N'2007-05-21' AS Date), N'9645711523', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'63479', N'35382289108')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'cae8fb67-9e4c-49ad-8db4-86b0b6a2e505', N'Juan', N'Gomez', CAST(N'2017-09-20' AS Date), N'7705240086', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'37326', N'35828461458')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'cb07ee65-98a1-411d-aeaf-5207afb08dd1', N'Cobura', N'Nieto', CAST(N'2008-11-15' AS Date), N'5523147395', N'27C89018-0534-480C-B719-5498EEE22D77', N'58196', N'37100150053')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'cb4b1781-008f-44eb-9f2c-174c1424a296', N'Celia', N'Torres', CAST(N'2014-01-15' AS Date), N'4969322047', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'79581', N'30403284792')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'cb504d38-9db0-4d42-a3ff-34d8b7d258f6', N'Cuba', N'Ruiz', CAST(N'2019-09-06' AS Date), N'6151296695', N'27C89018-0534-480C-B719-5498EEE22D77', N'32422', N'39793210634')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'cb59ee93-4d2f-4357-b6e3-af06cae2c6b7', N'Begoña', N'Cortes', CAST(N'2001-04-07' AS Date), N'1854784436', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'18459', N'30176625304')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'cb7258fb-f040-4682-9612-96112106a727', N'Facunda', N'Roman', CAST(N'2001-07-25' AS Date), N'1062473273', N'27C89018-0534-480C-B719-5498EEE22D77', N'46875', N'34948511375')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'cba4dba3-c404-4ba3-a2e2-5a14aaf2cbb0', N'Gael', N'Montero', CAST(N'2004-12-24' AS Date), N'9657048197', N'5526D776-861B-4085-9B5F-91D58221D161', N'97443', N'30649329615')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'cbbdcdee-7275-41f9-afbd-746f179cf6ca', N'Daniel', N'Herrero', CAST(N'2001-04-25' AS Date), N'6130969648', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'61643', N'39817774668')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'cbe1c3ca-9b0e-4944-8312-4b02598d189d', N'Noe', N'Prieto', CAST(N'2015-08-12' AS Date), N'4229394726', N'27C89018-0534-480C-B719-5498EEE22D77', N'95678', N'39284088094')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'cbe835b1-8caa-4663-a630-aa532a58df4d', N'Eva', N'Vicente', CAST(N'2019-02-17' AS Date), N'0365342157', N'27C89018-0534-480C-B719-5498EEE22D77', N'71443', N'31680280127')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'cbf25b74-202c-4a07-93a9-6aefe3f6c9e5', N'Vicenta', N'Nieto', CAST(N'2017-02-18' AS Date), N'6146928152', N'27C89018-0534-480C-B719-5498EEE22D77', N'11254', N'32445603835')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'cc016456-6bb7-4f9f-9433-eabdf29f73c7', N'Gig', N'Molina', CAST(N'2014-03-02' AS Date), N'9334470496', N'5526D776-861B-4085-9B5F-91D58221D161', N'18073', N'39655399863')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'cc1358c7-3509-4588-a1a2-e327aa62e4ba', N'Kevin', N'Prieto', CAST(N'2011-07-16' AS Date), N'2645110039', N'27C89018-0534-480C-B719-5498EEE22D77', N'56648', N'30245846888')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'cc382a54-c7a5-4ed4-940b-7c15b256b0c0', N'Juan José', N'Vazquez', CAST(N'2006-11-28' AS Date), N'3385139287', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'36220', N'36494980588')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'cc401cb2-257a-4702-8d96-68619af626af', N'Larenzo', N'Guerrero', CAST(N'2009-09-24' AS Date), N'8752334551', N'27C89018-0534-480C-B719-5498EEE22D77', N'70237', N'31339014913')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'cc83db18-ff48-4bbe-832d-b771b4376d86', N'Amparo', N'Garcia', CAST(N'2016-03-21' AS Date), N'9018702114', N'5526D776-861B-4085-9B5F-91D58221D161', N'61517', N'31006228956')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ccb4ed95-2bf0-4af6-9505-392c9449ee8f', N'Sandra', N'Montero', CAST(N'2002-10-19' AS Date), N'8189968215', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'62395', N'39171400212')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ccbccb2a-5655-41e7-b636-b6ff5152827a', N'Xaver', N'Vidal', CAST(N'2000-02-13' AS Date), N'6280190065', N'5526D776-861B-4085-9B5F-91D58221D161', N'86903', N'30883407697')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ccd6cf7c-f08b-480a-b2c3-8acb4d4c7209', N'Ginebra', N'Soler', CAST(N'2008-12-22' AS Date), N'2866875609', N'27C89018-0534-480C-B719-5498EEE22D77', N'38773', N'36913174276')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ccd7b03a-9b5d-421e-9c75-345e10e509d2', N'Fernanda', N'Lozano', CAST(N'2019-09-02' AS Date), N'0895943237', N'5526D776-861B-4085-9B5F-91D58221D161', N'01692', N'31143174971')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ccda04cf-c7e4-4829-b84c-064a7e352913', N'Teodora', N'Vazquez', CAST(N'2004-12-08' AS Date), N'6385782723', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'41848', N'35147413077')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'cd0e6298-959e-40e9-a8cf-ae76b5b1b92e', N'Eva', N'Garrido', CAST(N'2021-03-17' AS Date), N'5935584710', N'27C89018-0534-480C-B719-5498EEE22D77', N'09763', N'32277851661')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'cd36eaea-253f-4acd-9fa8-479f95db3cb1', N'Jacinta', N'Guerrero', CAST(N'2020-02-17' AS Date), N'7312360903', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'92661', N'33525853897')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'cd633ffd-1440-4486-b913-c9a1d75a6dd5', N'María Juana', N'Rey', CAST(N'2011-06-24' AS Date), N'1332611513', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'13622', N'37030532038')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'cd871e52-4a84-47c8-bf31-be8c3755c9ea', N'Zenon', N'Lopez', CAST(N'2002-03-09' AS Date), N'7525601471', N'27C89018-0534-480C-B719-5498EEE22D77', N'03491', N'35181949395')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'cdac712f-6293-4130-887b-b8db02db91ae', N'Christopher', N'Jimenez', CAST(N'2012-07-25' AS Date), N'8110806440', N'5526D776-861B-4085-9B5F-91D58221D161', N'83213', N'38897340966')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'cddcf391-b6f9-4c8e-b929-89472a6e6fe4', N'Jerrold', N'Herrero', CAST(N'2007-06-25' AS Date), N'0565095145', N'5526D776-861B-4085-9B5F-91D58221D161', N'72551', N'33278155041')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'cdfd345b-1707-447b-ba8b-25c855c0d77a', N'Larenzo', N'Pastor', CAST(N'2015-05-06' AS Date), N'7735326958', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'26394', N'30034662453')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ce367551-d008-402b-8b88-2b089116cbca', N'Valentina', N'Pardo', CAST(N'2013-12-20' AS Date), N'7510487394', N'5526D776-861B-4085-9B5F-91D58221D161', N'50674', N'34938803733')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ce519fbf-a001-4059-8d95-071a7596dfad', N'Paqui', N'Diaz', CAST(N'2004-11-03' AS Date), N'1385455789', N'27C89018-0534-480C-B719-5498EEE22D77', N'52465', N'37996575806')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ce6dcc1a-ba30-4d29-90ff-63d11f9ccd58', N'Max', N'Munoz', CAST(N'2021-02-16' AS Date), N'3515156045', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'94716', N'35569409418')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ce7102c3-e6af-4c3b-90af-e6fd5a71f763', N'Ximen', N'Garrido', CAST(N'2005-04-23' AS Date), N'6407487638', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'70437', N'34735604109')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ce75bb89-a82b-4c95-8bac-2b29f92ca8f0', N'Ana', N'Diez', CAST(N'2020-05-03' AS Date), N'4803598763', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'96482', N'33407755318')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ced02c02-27ee-4e8d-9447-90cb6820c1b4', N'Miguel Ángel', N'Lozano', CAST(N'2003-12-31' AS Date), N'5572703219', N'5526D776-861B-4085-9B5F-91D58221D161', N'60901', N'30082163761')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'cedad733-d79d-4233-be8b-16aab12512f6', N'Nicolas', N'Perez', CAST(N'2013-07-19' AS Date), N'3328335372', N'5526D776-861B-4085-9B5F-91D58221D161', N'46260', N'35626981291')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ceebd413-8752-49f4-84da-cc5b7c21d415', N'Ximena', N'Serrano', CAST(N'2009-02-21' AS Date), N'2092352605', N'27C89018-0534-480C-B719-5498EEE22D77', N'31047', N'35497973235')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'cf1c3524-82f6-4fa9-bd57-473852350dac', N'Laia', N'Martinez', CAST(N'2011-02-01' AS Date), N'3824773074', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'26848', N'38024388343')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'cf1dcf12-4cd2-4332-a026-82f5f193583e', N'dani', N'Cortes', CAST(N'2005-11-15' AS Date), N'6090543520', N'5526D776-861B-4085-9B5F-91D58221D161', N'37152', N'35650262030')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'cf524525-bafc-4adb-9b89-53539d3538ab', N'Aída', N'Pascual', CAST(N'2000-11-28' AS Date), N'7773929778', N'27C89018-0534-480C-B719-5498EEE22D77', N'12255', N'39264646506')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'cf6a27c2-532e-4b34-a405-924bf7f838d4', N'Thiago', N'Name', CAST(N'2012-02-02' AS Date), N'0727691298', N'27C89018-0534-480C-B719-5498EEE22D77', N'41393', N'38750485252')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'cfc9b6df-8b8f-4788-b105-ad1796c9d731', N'Jacinta', N'Suarez', CAST(N'2011-10-26' AS Date), N'3783084120', N'27C89018-0534-480C-B719-5498EEE22D77', N'99222', N'36898271353')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'cfe550aa-947f-4fcc-985c-afd105712de1', N'Jesús', N'Medina', CAST(N'2004-06-28' AS Date), N'4075139592', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'97795', N'36456339291')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd0109eec-3e13-4734-b37d-f5d2ff6b5692', N'Nilda', N'Diez', CAST(N'2017-01-26' AS Date), N'2455056346', N'27C89018-0534-480C-B719-5498EEE22D77', N'40660', N'37840268424')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd04efe3f-7056-4ccc-b5f0-89ea8f8f4d0b', N'Álvara', N'Vega', CAST(N'2008-10-03' AS Date), N'8268234174', N'27C89018-0534-480C-B719-5498EEE22D77', N'15221', N'36630550273')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd05803a8-f0e2-455f-8f86-a58f98c2439d', N'Nora', N'Guerrero', CAST(N'2001-08-04' AS Date), N'3370541595', N'27C89018-0534-480C-B719-5498EEE22D77', N'53113', N'38983428907')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd087f6ab-9ed9-43f0-a855-7838bb3dd075', N'Sonia', N'Vazquez', CAST(N'2001-06-30' AS Date), N'0335433327', N'5526D776-861B-4085-9B5F-91D58221D161', N'39997', N'38301450998')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd08d473d-23fe-4bbd-8a92-e753ff7314d7', N'guille', N'Martin', CAST(N'2009-09-08' AS Date), N'9100334240', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'58495', N'35912180551')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd0984a86-c05c-472f-adcb-d95d398811fa', N'Olga', N'Navarro', CAST(N'2005-04-28' AS Date), N'4335818486', N'27C89018-0534-480C-B719-5498EEE22D77', N'56519', N'36029190923')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd0dc6c8b-c15b-4884-b7c2-9eda4c1e36e6', N'Hortensia', N'Moreno', CAST(N'2014-04-19' AS Date), N'6798846037', N'5526D776-861B-4085-9B5F-91D58221D161', N'31036', N'30121974856')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd0f4737b-5c20-4378-bb8f-d3b7da9d6b3d', N'Plga', N'Serrano', CAST(N'2019-10-29' AS Date), N'7199091864', N'27C89018-0534-480C-B719-5498EEE22D77', N'95344', N'35380121857')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd0f672a1-3381-40e9-b6b3-228f79568c07', N'Milagros', N'Gomez', CAST(N'2016-11-16' AS Date), N'4088852814', N'5526D776-861B-4085-9B5F-91D58221D161', N'68262', N'33938218349')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd0f69f20-9cec-4f1d-8205-c0f80f3dd86a', N'Loredo', N'Blanco', CAST(N'2001-10-02' AS Date), N'8596392516', N'5526D776-861B-4085-9B5F-91D58221D161', N'67284', N'34201345867')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd0f96d3c-4a62-4f60-b077-dc77a3f800e7', N'Ignacio', N'Alvarez', CAST(N'2016-07-19' AS Date), N'2485132949', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'91305', N'31200783730')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd10c96bb-33d5-4614-932b-047798cb0289', N'Benjamín', N'Martin', CAST(N'2001-03-18' AS Date), N'8000054589', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'95194', N'31634898138')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd11efa47-b15c-48c4-9f80-54c3eac44cf2', N'Marina', N'Carmona', CAST(N'2011-07-29' AS Date), N'0199422296', N'5526D776-861B-4085-9B5F-91D58221D161', N'21212', N'30321433086')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd13cbf74-1f16-426c-a160-bcbad0fba1d3', N'Florencia', N'Morales', CAST(N'2013-07-13' AS Date), N'4562496421', N'5526D776-861B-4085-9B5F-91D58221D161', N'39491', N'36287489051')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd15a9570-b558-49a4-b54e-30248007d4a8', N'Maria', N'Castillo', CAST(N'2001-08-10' AS Date), N'6631208604', N'5526D776-861B-4085-9B5F-91D58221D161', N'93056', N'38701246660')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd1663e3d-d050-4c39-8e47-62eb8fabe27e', N'Tomasa', N'Sanz', CAST(N'2017-07-14' AS Date), N'3157891902', N'27C89018-0534-480C-B719-5498EEE22D77', N'97769', N'39019671309')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd170e962-df22-4792-9cb8-9e249b11b639', N'Franco', N'Bravo', CAST(N'2017-09-19' AS Date), N'2503022367', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'37509', N'33867608396')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd19e57b7-d500-4db4-afe9-e2af10dc5458', N'Soledad', N'Martinez', CAST(N'2014-03-27' AS Date), N'5185799775', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'77240', N'31822845089')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd222575d-1728-4d31-89b1-9d07c06841f0', N'Aurelia', N'Herrera', CAST(N'2012-01-16' AS Date), N'7018403727', N'27C89018-0534-480C-B719-5498EEE22D77', N'67921', N'38263316412')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd2339232-729a-4328-88fc-96805710803c', N'Ainara', N'Redondo', CAST(N'2014-08-22' AS Date), N'6099622123', N'27C89018-0534-480C-B719-5498EEE22D77', N'64740', N'38347790824')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd258e18b-3ddd-42ac-bfc6-f5a9406cd50c', N'Licha', N'Lorenzo', CAST(N'2006-04-24' AS Date), N'3810804186', N'27C89018-0534-480C-B719-5498EEE22D77', N'28072', N'35149204753')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd26fb33c-303c-4395-99eb-519fc2a7aa37', N'Javiera', N'Pena', CAST(N'2008-11-29' AS Date), N'5617387791', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'50434', N'38499422533')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd281e78f-83fa-4f29-9060-bc668bb0987e', N'Encarnación', N'Crespo', CAST(N'2021-06-19' AS Date), N'5705081811', N'27C89018-0534-480C-B719-5498EEE22D77', N'57312', N'39036620961')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd2ec00a9-f071-4a36-978b-44f560d1b4f8', N'Elías', N'Hernandez', CAST(N'2016-01-22' AS Date), N'7053948123', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'47394', N'39345463702')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd3351b60-a332-486f-846c-a7e4f09e24e3', N'Leonor', N'Garcia', CAST(N'2005-03-31' AS Date), N'1104170356', N'27C89018-0534-480C-B719-5498EEE22D77', N'23484', N'39427738280')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd3be7373-cebb-4ebb-9c6d-1e04f6c07686', N'Carlos', N'Gil', CAST(N'2010-11-11' AS Date), N'1347989601', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'82377', N'34372043378')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd3db9bbd-8284-4e54-931a-808848ec54ee', N'Jair', N'Flores', CAST(N'2012-10-17' AS Date), N'0278097028', N'27C89018-0534-480C-B719-5498EEE22D77', N'95146', N'34207448443')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd440bafd-51af-48c1-89be-61c20998906b', N'Eva', N'Mora', CAST(N'2016-03-27' AS Date), N'3039311483', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'40702', N'36813578438')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd44baa2c-6f8b-4b29-ab56-9cc74af6e321', N'Ilda', N'Arias', CAST(N'2006-03-26' AS Date), N'4771098663', N'27C89018-0534-480C-B719-5498EEE22D77', N'16978', N'32693147765')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd45f5cc1-4f8d-495a-b66b-220b50155957', N'Keiko', N'Suarez', CAST(N'2005-04-03' AS Date), N'6641520432', N'27C89018-0534-480C-B719-5498EEE22D77', N'45317', N'36671537762')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd4f42698-68a5-4703-a18d-d32937d977e0', N'Pascuala', N'Marquez', CAST(N'2019-02-08' AS Date), N'0802668159', N'5526D776-861B-4085-9B5F-91D58221D161', N'86540', N'37366388542')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd5012e40-2420-4f36-9b96-5909a2cd3950', N'Alexander', N'Perez', CAST(N'2001-07-26' AS Date), N'0069972918', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'54699', N'38757058674')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd56a687e-c24e-4a0d-913c-f6f11d88f978', N'Juanma', N'Cortes', CAST(N'2007-03-26' AS Date), N'1450918600', N'27C89018-0534-480C-B719-5498EEE22D77', N'58124', N'35140438289')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd58e2645-7bfd-4d3c-a1fe-724d92e224e3', N'Ricardo', N'Munoz', CAST(N'2012-06-11' AS Date), N'7157802378', N'27C89018-0534-480C-B719-5498EEE22D77', N'09417', N'39224526154')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd5a63cdb-e104-43c9-b740-90f1a1df55b2', N'Feliciana', N'Mora', CAST(N'2000-03-21' AS Date), N'6878109120', N'27C89018-0534-480C-B719-5498EEE22D77', N'72048', N'31519716424')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd5dffea4-84ef-40ac-b188-f5385741c6e0', N'Nicolas', N'Name', CAST(N'2004-12-21' AS Date), N'1540640719', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'70094', N'37318299280')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd5f18d60-9072-4735-a872-d2a47a8d9e38', N'Kiki', N'Navarro', CAST(N'2018-03-13' AS Date), N'4397265159', N'27C89018-0534-480C-B719-5498EEE22D77', N'59098', N'33763997046')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd61510e2-469f-4b2d-9bfd-5b32f9dc63cb', N'Camila', N'Lozano', CAST(N'2018-05-23' AS Date), N'6312871231', N'27C89018-0534-480C-B719-5498EEE22D77', N'13515', N'39561784514')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd647b912-c5fe-48d7-bdc6-09593fe2b8b1', N'Cruz', N'Gonzalez', CAST(N'2016-10-18' AS Date), N'8392530621', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'62982', N'33266819909')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd65f5012-43ee-4f15-aec6-f4efafb2acda', N'Dante', N'Hernandez', CAST(N'2000-09-19' AS Date), N'5955267405', N'27C89018-0534-480C-B719-5498EEE22D77', N'41044', N'33653889807')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd6677556-c6b1-4b09-9017-7ca62dfae2b3', N'Toni', N'Munoz', CAST(N'2012-08-25' AS Date), N'9970334781', N'27C89018-0534-480C-B719-5498EEE22D77', N'64662', N'36424065529')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd670b9a7-fbde-4c03-882c-7c11726ad719', N'Mari', N'Ibanez', CAST(N'2000-10-09' AS Date), N'3800872433', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'97521', N'35974787305')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd682c20d-d41d-4e50-abcd-9c5ce8c07d7e', N'Andy', N'Mora', CAST(N'2013-01-10' AS Date), N'2125108597', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'57640', N'30752249195')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd699f7aa-e4e7-4411-b270-5def94b7df36', N'Patri', N'Medina', CAST(N'2015-03-02' AS Date), N'7601212525', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'55834', N'39741317375')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd6ed8c8c-0181-444a-9936-ecf70dccd6bd', N'Joaquin', N'Vazquez', CAST(N'2018-01-24' AS Date), N'8732503606', N'27C89018-0534-480C-B719-5498EEE22D77', N'97853', N'33619736885')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd6f394d2-80ee-4d15-afe7-1798f4e8bc47', N'Pablo', N'Reyes', CAST(N'2004-03-21' AS Date), N'1955652262', N'5526D776-861B-4085-9B5F-91D58221D161', N'34313', N'38410514149')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd7213305-e075-41dd-b050-3dd7ce6e3227', N'Nerea', N'Nunez', CAST(N'2014-08-26' AS Date), N'9482342254', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'38900', N'36175283872')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd72ecba3-2366-41cd-8d30-3ef59ba807dd', N'Xeres', N'Vidal', CAST(N'2007-12-15' AS Date), N'6410304578', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'11986', N'30765730048')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd7c76407-38e1-4592-a722-df1a09d60585', N'Iker', N'Molina', CAST(N'2019-02-11' AS Date), N'6247491913', N'27C89018-0534-480C-B719-5498EEE22D77', N'69193', N'34017014856')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd7c7c631-72c6-4f81-9086-1ff5b11314d5', N'Alex', N'Nieto', CAST(N'2014-07-22' AS Date), N'0943040893', N'27C89018-0534-480C-B719-5498EEE22D77', N'65540', N'30599888939')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd809aa06-5120-4775-9297-24e1bf5bf3e3', N'Sara', N'Menendez', CAST(N'2005-10-10' AS Date), N'6905693786', N'27C89018-0534-480C-B719-5498EEE22D77', N'76291', N'39143793166')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd82c31ee-d9b0-4130-850d-a4ea9e8e7c65', N'Clotilde', N'Castro', CAST(N'2003-07-05' AS Date), N'8969320796', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'09017', N'38846473968')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd886c300-87ac-4a8f-8613-fdce5866fce6', N'Rafael', N'Caballero', CAST(N'2007-08-23' AS Date), N'5208613762', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'27113', N'36666558382')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd8989301-cc33-4b12-9182-bd948df18cf9', N'Itahisa', N'Gomez', CAST(N'2021-06-13' AS Date), N'0503794151', N'5526D776-861B-4085-9B5F-91D58221D161', N'39758', N'38355160313')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd8a5ced6-87c0-490f-872f-7e70313a410f', N'Alonso', N'Carmona', CAST(N'2015-10-02' AS Date), N'9657510550', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'20528', N'31702951059')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd8a7101f-6df1-4701-8509-d49407401cdd', N'Hilda', N'Rodriguez', CAST(N'2021-09-23' AS Date), N'2841148995', N'27C89018-0534-480C-B719-5498EEE22D77', N'18978', N'35586045256')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd8cdbed7-a8ba-4522-8f91-6918c8a57d37', N'Olga', N'Lozano', CAST(N'2007-01-14' AS Date), N'5628893774', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'52528', N'34456480687')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd92504f2-5dec-485d-aa92-705efadc2073', N'David', N'Medina', CAST(N'2017-05-08' AS Date), N'1124156729', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'21872', N'34867701623')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd95ba0e0-6942-4042-bdf3-67baebdfcfa7', N'Maite', N'Diaz', CAST(N'2019-05-08' AS Date), N'3560326223', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'31592', N'36626748449')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd970f2da-a2e6-4c15-a956-00294f2d67b2', N'Xaver', N'Menendez', CAST(N'2012-03-10' AS Date), N'5752268512', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'38130', N'36079286720')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd982083e-1cc3-4612-9ffe-3febf6be1bca', N'Juan Manuel', N'Moreno', CAST(N'2011-03-02' AS Date), N'0909445861', N'27C89018-0534-480C-B719-5498EEE22D77', N'91070', N'35359334990')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd99b834a-b2f8-4d7a-8427-483997fa4266', N'Caleb', N'Velasco', CAST(N'2006-02-15' AS Date), N'9718650077', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'57648', N'32044364658')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd9c52be9-dbba-4c5f-a309-cfde16f1978d', N'Tania', N'Hernandez', CAST(N'2013-10-22' AS Date), N'6028181446', N'27C89018-0534-480C-B719-5498EEE22D77', N'58012', N'34306844951')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd9d34eff-1834-42cf-9e43-e1645c44304f', N'Trysta', N'Guerrero', CAST(N'2016-11-06' AS Date), N'3051207670', N'27C89018-0534-480C-B719-5498EEE22D77', N'70309', N'39547374215')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd9ee6d3f-8907-4686-84ca-152d6bf369ba', N'Purificación', N'Diaz', CAST(N'2001-10-22' AS Date), N'1851793217', N'5526D776-861B-4085-9B5F-91D58221D161', N'77095', N'35160260441')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'd9ef2a7f-5f29-4c8d-b078-e2e705af5a47', N'Berto', N'Santos', CAST(N'2018-06-22' AS Date), N'8422123264', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'58087', N'34103751145')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'da27eabb-c80e-4e4b-aeb6-e81f1116689d', N'Maribel', N'Ortega', CAST(N'2014-03-12' AS Date), N'8446244392', N'5526D776-861B-4085-9B5F-91D58221D161', N'57035', N'34261228373')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'da297260-5928-4603-bb32-788f865eee04', N'Almudena', N'Nieto', CAST(N'2017-05-30' AS Date), N'8187980886', N'27C89018-0534-480C-B719-5498EEE22D77', N'74979', N'38029109870')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'da29950d-9bc7-4f9c-9b01-bc21377ee322', N'Carlos', N'Morales', CAST(N'2013-08-02' AS Date), N'7399971597', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'38827', N'32408456262')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'da7d434c-b2a5-495a-9b9d-91ec43610018', N'Eduardo', N'Saez', CAST(N'2001-07-04' AS Date), N'1894392049', N'27C89018-0534-480C-B719-5498EEE22D77', N'77308', N'32894449501')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'da938dec-c414-4def-a8fb-a99acfad3c3f', N'Tamara', N'Serrano', CAST(N'2001-05-26' AS Date), N'8626223484', N'27C89018-0534-480C-B719-5498EEE22D77', N'49869', N'33397915082')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'dab9211c-7c44-4cd6-93a4-f9a349e74f32', N'Catalina', N'Hernandez', CAST(N'2003-05-28' AS Date), N'2481793066', N'27C89018-0534-480C-B719-5498EEE22D77', N'06429', N'32691207677')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'dae1766f-8c4e-44db-9c6d-bef61195414a', N'Montel', N'Moya', CAST(N'2002-12-13' AS Date), N'0813195530', N'5526D776-861B-4085-9B5F-91D58221D161', N'15035', N'38808345943')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'db544d64-c092-449c-980d-3296aabc8fb2', N'Fulberta', N'Nieto', CAST(N'2009-05-03' AS Date), N'8014089849', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'97315', N'36084430205')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'db59fa6d-d084-4adc-b1b1-a7aed48b7a76', N'Axel', N'Menendez', CAST(N'2013-06-01' AS Date), N'0902416584', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'72127', N'31784592228')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'db6b83a1-af93-4aac-9fe1-66681cce2371', N'Xabat', N'Marquez', CAST(N'2003-02-20' AS Date), N'9360766796', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'89760', N'31130296790')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'db8618ee-26fb-4918-b847-951815fb0a2d', N'Ramira', N'Aguilar', CAST(N'2000-06-03' AS Date), N'3029238303', N'5526D776-861B-4085-9B5F-91D58221D161', N'23835', N'38359053877')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'db8e24da-90b7-4d8c-ad84-88bb19333bb9', N'Filomena', N'Fernandez', CAST(N'2011-12-15' AS Date), N'9837968714', N'5526D776-861B-4085-9B5F-91D58221D161', N'77668', N'35324526550')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'db990880-8a1b-4911-bfff-48bb1dfb2ac2', N'Vane', N'Ortega', CAST(N'2002-03-14' AS Date), N'0708917035', N'5526D776-861B-4085-9B5F-91D58221D161', N'94479', N'30829500560')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'dbcd4d2a-ac18-4550-83e0-7b27f02fb6f2', N'Antonio', N'Vidal', CAST(N'2019-12-28' AS Date), N'9275287519', N'27C89018-0534-480C-B719-5498EEE22D77', N'02653', N'30635146917')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'dbdc519a-f98e-43f0-9044-f938d43a0baa', N'Ascensión', N'Castillo', CAST(N'2016-03-28' AS Date), N'3824135154', N'27C89018-0534-480C-B719-5498EEE22D77', N'20585', N'34946860094')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'dc0cf3e2-ad9f-4aaa-bac7-b8d11dc279f3', N'Magdalena', N'Leon', CAST(N'2016-07-07' AS Date), N'7016646392', N'5526D776-861B-4085-9B5F-91D58221D161', N'70614', N'31966886429')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'dc1318ed-fe47-4b67-952f-6fa28d9e1a65', N'Manuel', N'Vazquez', CAST(N'2005-04-06' AS Date), N'3980027706', N'5526D776-861B-4085-9B5F-91D58221D161', N'81577', N'35334423386')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'dc50f86e-a113-451d-9ece-6924e87f8f13', N'Isidro', N'Cano', CAST(N'2018-10-13' AS Date), N'4471469270', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'15563', N'39476727965')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'dc7bc50d-9c36-4289-8f8e-fdb23c76d72a', N'Santi', N'Fuentes', CAST(N'2000-01-02' AS Date), N'7034419241', N'27C89018-0534-480C-B719-5498EEE22D77', N'41214', N'38148854467')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'dc9a8c82-e3f3-4bba-972a-9a5148245c0e', N'David', N'Cabrera', CAST(N'2001-10-19' AS Date), N'0215391868', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'59371', N'39507737376')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'dca552d8-e0ea-4528-9b9c-3e336f582a47', N'Feliciana', N'Diaz', CAST(N'2010-12-29' AS Date), N'3171749080', N'5526D776-861B-4085-9B5F-91D58221D161', N'78568', N'36830005596')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'dce71e88-3fb9-4b42-ae06-7e093001904e', N'Estela', N'Cabrera', CAST(N'2015-10-06' AS Date), N'0651387629', N'27C89018-0534-480C-B719-5498EEE22D77', N'84635', N'39724423637')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'dd0cd545-ba64-4a81-aac5-2ccd04851b13', N'Catalina', N'Marcos', CAST(N'2015-07-11' AS Date), N'4839484945', N'5526D776-861B-4085-9B5F-91D58221D161', N'60796', N'32259214800')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'dd1436d3-8282-4096-9d71-0b53571009d4', N'Dalila', N'Cortes', CAST(N'2006-05-03' AS Date), N'8723132305', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'54795', N'38437756331')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'dd1c05d5-2b5c-460c-8458-32d31ea2c5c7', N'Hugo', N'Campos', CAST(N'2012-09-16' AS Date), N'8910937182', N'5526D776-861B-4085-9B5F-91D58221D161', N'63817', N'36606890356')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'dd22be7d-79fe-48f7-9aad-a21340c409b3', N'Rebeca', N'Sanz', CAST(N'2011-11-04' AS Date), N'1287273490', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'80101', N'30840529665')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'dd59fb1f-acdc-497d-9bee-91fde02961d2', N'Gonzalo', N'Montero', CAST(N'2007-10-25' AS Date), N'8191880011', N'5526D776-861B-4085-9B5F-91D58221D161', N'44588', N'37977996878')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'dd883799-8891-4fd5-b609-0fa712a3a733', N'Pepe', N'Ortega', CAST(N'2020-05-27' AS Date), N'2601733099', N'5526D776-861B-4085-9B5F-91D58221D161', N'55866', N'33086734442')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'dd963bd2-4f88-4b4b-b8ce-c16083cc9b55', N'Cobura', N'Castillo', CAST(N'2004-03-10' AS Date), N'5860571446', N'27C89018-0534-480C-B719-5498EEE22D77', N'87382', N'34181373039')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ddbf50a6-8363-4333-96d6-bf8ef15752a8', N'Isaac', N'Munoz', CAST(N'2021-09-25' AS Date), N'6636701504', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'25666', N'39427412656')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'dde488fa-d0a2-4243-a72a-4767eb45bfd3', N'Joan', N'Marcos', CAST(N'2004-05-05' AS Date), N'2750754490', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'03966', N'30977256732')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ddfd02b1-5705-4905-9c76-86990aea02d6', N'Albert', N'Gil', CAST(N'2000-04-02' AS Date), N'8105444244', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'70576', N'34800337499')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'de1d708f-d953-46c4-9a7c-b192af4e41fd', N'Patricio', N'Name', CAST(N'2008-10-20' AS Date), N'9012322539', N'27C89018-0534-480C-B719-5498EEE22D77', N'83138', N'34458372768')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'de2f48a6-48fc-4623-a035-ab10432aeec9', N'Araceli', N'Ortega', CAST(N'2014-05-22' AS Date), N'0151052346', N'27C89018-0534-480C-B719-5498EEE22D77', N'37392', N'32133126455')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'de3b3980-e060-4322-a24a-a62c3fe84d33', N'Tamara', N'Martinez', CAST(N'2019-10-28' AS Date), N'8606855305', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'57331', N'35350039231')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'de90cc6f-7fd0-460d-9d82-14eea5d3e3ef', N'Juanita', N'Rubio', CAST(N'2007-09-29' AS Date), N'8640974350', N'27C89018-0534-480C-B719-5498EEE22D77', N'75027', N'33057752044')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'dee3b1fe-916a-4e44-8d27-814c93ad4b4b', N'Magdalena', N'Cabrera', CAST(N'2011-02-08' AS Date), N'5211152194', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'60330', N'37093553351')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'df22fde4-542d-432a-9cc1-662570258257', N'Loredo', N'Ferrer', CAST(N'2020-04-06' AS Date), N'0583966892', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'19325', N'37195312489')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'df4803c4-40c9-4b58-bd51-a6d77a0595d0', N'Alberto', N'Roman', CAST(N'2014-01-30' AS Date), N'0978409353', N'27C89018-0534-480C-B719-5498EEE22D77', N'76160', N'37258908949')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'dfa1807c-8cf6-4863-90f3-778ac62c6fd9', N'Trinidad', N'Caballero', CAST(N'2004-12-30' AS Date), N'7263760788', N'5526D776-861B-4085-9B5F-91D58221D161', N'09107', N'32531266368')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'dffc1803-f546-4be7-9070-21481ee48cae', N'Mario', N'Suarez', CAST(N'2020-09-26' AS Date), N'2133944378', N'27C89018-0534-480C-B719-5498EEE22D77', N'57462', N'30812843220')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e001420a-22ca-4890-b644-d5a4984a7b64', N'Emiliano', N'Alvarez', CAST(N'2007-04-26' AS Date), N'2657224436', N'5526D776-861B-4085-9B5F-91D58221D161', N'49273', N'31243334260')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e0244d4f-cb29-4f02-b32d-26834eaf9890', N'Ángeles', N'Leon', CAST(N'2003-05-12' AS Date), N'7479848207', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'59719', N'33848182000')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e045d42b-94e2-44f3-b778-d537a4067626', N'Emmanuel', N'Fernandez', CAST(N'2019-01-08' AS Date), N'1400250489', N'5526D776-861B-4085-9B5F-91D58221D161', N'67327', N'32742870739')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e07e2aba-4ec6-4463-99b0-bac27040945b', N'Fraco', N'Saez', CAST(N'2015-11-14' AS Date), N'2446081350', N'27C89018-0534-480C-B719-5498EEE22D77', N'37075', N'32423270985')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e0c3c668-dcb5-46d4-a68c-53bd17a17c4a', N'Jennifer', N'Soler', CAST(N'2005-02-08' AS Date), N'3613862047', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'96199', N'37888158086')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e0c51409-1c2e-4002-813c-3f6322b1a6bb', N'Gervasio', N'Andres', CAST(N'2015-06-27' AS Date), N'2884354637', N'5526D776-861B-4085-9B5F-91D58221D161', N'50831', N'33797518176')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e0eece25-57ae-464a-8adc-ecf45051f1e4', N'Joaquin', N'Jimenez', CAST(N'2008-06-28' AS Date), N'1862647515', N'5526D776-861B-4085-9B5F-91D58221D161', N'37366', N'31250999299')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e12939f3-51b5-46b7-9bc6-5373c175fe59', N'Alodia', N'Crespo', CAST(N'2021-11-22' AS Date), N'6578290103', N'5526D776-861B-4085-9B5F-91D58221D161', N'66446', N'33503875297')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e13528a7-8380-413f-bdfd-3e5aebeae697', N'Mariana', N'Perez', CAST(N'2003-03-19' AS Date), N'1001692853', N'27C89018-0534-480C-B719-5498EEE22D77', N'47212', N'30181562347')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e163a0be-7ed2-42b9-9509-220446ac55fe', N'Enrique', N'Vidal', CAST(N'2000-05-22' AS Date), N'0779036120', N'5526D776-861B-4085-9B5F-91D58221D161', N'35961', N'33231234058')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e16b2312-2127-4b44-81c5-7e990639ce25', N'Nieves', N'Calvo', CAST(N'2017-01-20' AS Date), N'3164784378', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'28272', N'31317318540')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e18b325b-b0ac-46bb-ba74-ca3a875b4e6c', N'Federico', N'Arias', CAST(N'2008-03-14' AS Date), N'4551185255', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'15577', N'39618737766')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e19015e9-1693-4ce8-9661-7714ad999a6c', N'First names', N'Duran', CAST(N'2002-09-28' AS Date), N'9213672942', N'5526D776-861B-4085-9B5F-91D58221D161', N'03316', N'36290401024')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e1901add-fff1-4642-b842-57025a428ad0', N'Ximen', N'Reyes', CAST(N'2020-09-14' AS Date), N'6666701389', N'27C89018-0534-480C-B719-5498EEE22D77', N'77485', N'31388559730')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e1971dad-bb2c-4e11-ac30-c0d589e1f4a3', N'Hilario', N'Duran', CAST(N'2015-04-13' AS Date), N'1962206085', N'27C89018-0534-480C-B719-5498EEE22D77', N'85505', N'35894305340')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e1b9b460-4ad7-4bcc-9166-07fe02154a3d', N'Josep', N'Pascual', CAST(N'2011-06-29' AS Date), N'1539679475', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'60795', N'35023719587')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e1edb7bb-24a0-4087-aa36-8e7db653363a', N'Noemí', N'Castro', CAST(N'2015-04-09' AS Date), N'8067228564', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'10193', N'31034396196')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e20cba58-a312-42d7-a15d-9516dbe92775', N'Aarón', N'Menendez', CAST(N'2001-09-02' AS Date), N'4372189306', N'27C89018-0534-480C-B719-5498EEE22D77', N'36755', N'35595771509')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e220f52a-bd97-472e-91e0-66bbbea0d95a', N'Modesta', N'Gil', CAST(N'2013-02-08' AS Date), N'3564757294', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'90875', N'30102032540')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e27c0d7c-96b3-46d3-8dff-f02c8b949b6c', N'Gael', N'Ibanez', CAST(N'2021-11-22' AS Date), N'5127355175', N'5526D776-861B-4085-9B5F-91D58221D161', N'97313', N'31939495846')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e283c888-6f05-4be3-b9c7-008c6243cd9e', N'Uxue', N'Santos', CAST(N'2015-09-16' AS Date), N'0251976478', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'45780', N'32949218511')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e29505df-510a-4847-98bb-e0c9757d7020', N'Juanma', N'Cruz', CAST(N'2003-12-07' AS Date), N'4286208133', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'68881', N'33405891109')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e2978ac4-c51c-4a7e-a767-7d3db2ef4386', N'Judith', N'Ramirez', CAST(N'2012-08-21' AS Date), N'7576758889', N'5526D776-861B-4085-9B5F-91D58221D161', N'11899', N'32851745922')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e2a2c409-e6db-4ffe-a890-8418571b95eb', N'Jose manuel', N'Vila', CAST(N'2005-02-07' AS Date), N'2379993921', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'33069', N'37303928040')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e2aaab15-affc-4481-829a-ee6e02994cd0', N'Vane', N'Vila', CAST(N'2012-06-13' AS Date), N'3313072540', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'60686', N'36981257938')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e2bd5685-83d7-4382-905f-3a336ac19855', N'Alexander', N'Martinez', CAST(N'2009-03-06' AS Date), N'0158221667', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'04743', N'32911941647')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e2bd9a23-d47b-436d-9c95-de10a1975ffd', N'Luciano', N'Vidal', CAST(N'2004-11-28' AS Date), N'2642590361', N'5526D776-861B-4085-9B5F-91D58221D161', N'15609', N'35578849788')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e2cb6126-b333-4f46-9548-6cceed5c7c06', N'Laia', N'Flores', CAST(N'2008-08-14' AS Date), N'2311710374', N'27C89018-0534-480C-B719-5498EEE22D77', N'99104', N'33288773007')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e2d09a14-f85c-46b8-9318-e0810c6ac3b3', N'Roberto', N'Rey', CAST(N'2004-06-07' AS Date), N'0702241416', N'5526D776-861B-4085-9B5F-91D58221D161', N'93243', N'33276474002')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e2f8450b-552b-4ca6-a7f3-37ef3cc54741', N'Neper', N'Lorenzo', CAST(N'2017-12-03' AS Date), N'7845195517', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'25629', N'35929001125')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e3110f9a-c6a1-45c7-a9a4-fd63a2ee3f11', N'Feliciana', N'Santos', CAST(N'2005-08-10' AS Date), N'6301968574', N'5526D776-861B-4085-9B5F-91D58221D161', N'84218', N'36821790424')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e34142e9-3711-42f4-bb93-41c4de08f737', N'Carlos', N'Hernandez', CAST(N'2008-11-24' AS Date), N'3590423707', N'27C89018-0534-480C-B719-5498EEE22D77', N'94012', N'32787059797')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e34dfbca-d148-4a9a-946e-185eb50acba2', N'Gonzalo', N'Flores', CAST(N'2018-10-10' AS Date), N'7984027102', N'27C89018-0534-480C-B719-5498EEE22D77', N'00170', N'33122832428')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e3bb2d70-c85f-4a86-9d57-f82aa985c244', N'Fulberta', N'Serrano', CAST(N'2004-09-15' AS Date), N'4424149208', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'83573', N'38955716912')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e476683d-a0fd-48d5-b089-fcd109f537fd', N'Magdalena', N'Carmona', CAST(N'2021-04-19' AS Date), N'7653577703', N'5526D776-861B-4085-9B5F-91D58221D161', N'31365', N'36376754954')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e48aa506-7efd-4535-99e8-752af77b41d1', N'Fran', N'Castillo', CAST(N'2014-07-23' AS Date), N'3082667847', N'5526D776-861B-4085-9B5F-91D58221D161', N'29483', N'34497095574')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e50053be-5d90-4a04-a1e9-8cc03337b160', N'Adisoda', N'Herrero', CAST(N'2010-01-31' AS Date), N'6608972262', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'87938', N'38431136492')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e523e611-72fe-4480-90a0-4174cb32d039', N'Amelia', N'Moya', CAST(N'2013-02-04' AS Date), N'1554936459', N'5526D776-861B-4085-9B5F-91D58221D161', N'97659', N'31589690052')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e5244b4d-eefd-4736-a4b2-9cafdbcf67ee', N'Yaiza', N'Name', CAST(N'2018-04-20' AS Date), N'6500519394', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'41419', N'35209735903')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e540d58d-4fd8-48e4-b2bd-754485697357', N'Ignacio', N'Calvo', CAST(N'2010-03-05' AS Date), N'9363461175', N'27C89018-0534-480C-B719-5498EEE22D77', N'07461', N'30503296791')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e604c933-1dd9-4ab4-a0d3-d3ce372cb14d', N'María Jesús', N'Arias', CAST(N'2013-12-26' AS Date), N'9811397320', N'27C89018-0534-480C-B719-5498EEE22D77', N'06055', N'35377255154')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e666defa-0287-46c0-a728-365377ef9c4f', N'Bruno', N'Menendez', CAST(N'2016-01-03' AS Date), N'8195652515', N'5526D776-861B-4085-9B5F-91D58221D161', N'47507', N'36040383412')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e6b87178-4239-4a96-9e1a-435abdd61ada', N'Borja', N'Dominguez', CAST(N'2009-11-16' AS Date), N'4313061487', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'18234', N'39858257105')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e6cc143a-abc0-406d-bbfc-7987d423dbae', N'Xaver', N'Gil', CAST(N'2017-12-16' AS Date), N'3977263580', N'27C89018-0534-480C-B719-5498EEE22D77', N'13974', N'33106802464')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e6ee9329-1f9d-487a-9425-680b55571b66', N'Esther', N'Gil', CAST(N'2010-10-04' AS Date), N'3366135081', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'89990', N'30045584363')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e70c71ee-3d36-4d52-97d7-fd9b28e330a5', N'Bruno', N'Carrasco', CAST(N'2011-03-28' AS Date), N'4624689182', N'27C89018-0534-480C-B719-5498EEE22D77', N'83040', N'33430723682')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e70f2028-b8a9-4a4c-9a78-853ef38d5874', N'Josefa', N'Perez', CAST(N'2019-08-26' AS Date), N'8219670309', N'27C89018-0534-480C-B719-5498EEE22D77', N'29340', N'37721195388')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e70f5138-2739-4172-ae3a-ae9b83fcf21e', N'Matías', N'Moreno', CAST(N'2019-07-07' AS Date), N'7350796137', N'5526D776-861B-4085-9B5F-91D58221D161', N'27534', N'34072656084')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e7165140-525e-49e7-9172-2fe0304ec594', N'Nasario', N'Fernandez', CAST(N'2002-05-13' AS Date), N'3398902135', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'05133', N'32648683375')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e731011e-c547-43ae-80b1-776aed219cfd', N'Modesta', N'Blanco', CAST(N'2001-04-29' AS Date), N'9392345031', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'60203', N'32766300047')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e76468e0-9bd8-42a0-848a-731ebeea1945', N'Xabat', N'Aguilar', CAST(N'2005-03-11' AS Date), N'0671522501', N'27C89018-0534-480C-B719-5498EEE22D77', N'92755', N'33746392166')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e795dfb0-5412-4682-91db-af3d61a58959', N'Xabat', N'Sanchez', CAST(N'2005-10-05' AS Date), N'1368847815', N'27C89018-0534-480C-B719-5498EEE22D77', N'47195', N'35361536451')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e7b5a540-733f-4345-87c1-bda300658d7f', N'Chaxiraxi', N'Cruz', CAST(N'2016-11-03' AS Date), N'3772126864', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'19362', N'39727741675')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e7e6fdc3-e07a-4a3a-a491-6422ea44562f', N'Ivan', N'Vazquez', CAST(N'2018-02-22' AS Date), N'7846685337', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'78468', N'30032636270')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e81066ca-4ac1-491d-a948-f26491d5ece0', N'Óscar', N'Vidal', CAST(N'2017-07-13' AS Date), N'6612617299', N'27C89018-0534-480C-B719-5498EEE22D77', N'40944', N'37495829366')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e816befb-ef89-4092-8699-603ed597cd8f', N'Montego', N'Leon', CAST(N'2004-06-15' AS Date), N'8908228300', N'5526D776-861B-4085-9B5F-91D58221D161', N'38520', N'39039984466')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e8197716-8c08-4843-8529-f167bc14fa44', N'Adriana', N'Marquez', CAST(N'2013-11-27' AS Date), N'4331594394', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'87650', N'36378678914')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e8808100-18d9-4460-a406-409d70aea1c2', N'Frida', N'Gimenez', CAST(N'2017-04-05' AS Date), N'8248761788', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'24526', N'35221665557')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e8815fc9-357a-42b5-971f-fd6c919c6492', N'Lupita', N'Garcia', CAST(N'2021-11-17' AS Date), N'0182174102', N'27C89018-0534-480C-B719-5498EEE22D77', N'32570', N'37016789902')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e88f3ac4-9582-4b74-abe1-9cd13d840dd4', N'Julen', N'Alonso', CAST(N'2012-09-21' AS Date), N'4924765649', N'5526D776-861B-4085-9B5F-91D58221D161', N'40188', N'30657406371')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e8b511ae-64f1-4109-ad6f-d2f9886ae88f', N'Lucia', N'Guerrero', CAST(N'2017-10-29' AS Date), N'2895097373', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'51294', N'32025204544')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e8efe794-2928-4d1c-8c4c-c5d8687d533e', N'Neron', N'Pena', CAST(N'2020-01-08' AS Date), N'1707274216', N'27C89018-0534-480C-B719-5498EEE22D77', N'92166', N'39041120884')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e8ff6d32-9456-4800-9d33-350138f86f79', N'Selena', N'Lorenzo', CAST(N'2006-06-23' AS Date), N'8914819092', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'40794', N'31456034091')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e934d0f8-573b-4622-8b6d-f0accc744a76', N'Floria', N'Vidal', CAST(N'2015-04-23' AS Date), N'0567615840', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'86758', N'30938378249')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e93c8353-bfe3-46c9-b19e-0e3fb65eb4a7', N'Emilio', N'Duran', CAST(N'2008-05-24' AS Date), N'2826537978', N'27C89018-0534-480C-B719-5498EEE22D77', N'96629', N'32311159618')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e9594477-1739-446b-98f0-12b5295f8a06', N'Ariadna', N'Andres', CAST(N'2005-04-25' AS Date), N'0274857834', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'82759', N'31830963943')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e9a94e76-5fb5-4a45-b2d6-ce3759fa52f8', N'Santi', N'Cabrera', CAST(N'2010-01-22' AS Date), N'7765719941', N'5526D776-861B-4085-9B5F-91D58221D161', N'59503', N'33389517531')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e9c06532-2e49-4317-9f63-6a511eadf91b', N'dani', N'Pastor', CAST(N'2009-12-03' AS Date), N'6872727232', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'67248', N'39389908926')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e9cfbba0-c525-405e-b63a-7d40d131fa50', N'Anna', N'Gil', CAST(N'2001-11-06' AS Date), N'8374784899', N'5526D776-861B-4085-9B5F-91D58221D161', N'73476', N'33134876351')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e9df04b4-8bb6-4b3c-97c3-51285639a25b', N'Damián', N'Lorenzo', CAST(N'2017-07-01' AS Date), N'4462956031', N'27C89018-0534-480C-B719-5498EEE22D77', N'75264', N'37634594732')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e9e30705-1e70-4d6f-8eff-2fe01b9308ca', N'Inmaculada', N'Prieto', CAST(N'2009-10-31' AS Date), N'7241105948', N'5526D776-861B-4085-9B5F-91D58221D161', N'92363', N'33265508137')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'e9f86681-bf9c-416d-a170-1631e4930bde', N'Eneko', N'Hidalgo', CAST(N'2019-05-23' AS Date), N'2749714866', N'27C89018-0534-480C-B719-5498EEE22D77', N'55657', N'31351631423')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ea1136ba-2132-42d3-b497-afd07d89a006', N'Juan José', N'Castro', CAST(N'2021-01-21' AS Date), N'3156068650', N'5526D776-861B-4085-9B5F-91D58221D161', N'80840', N'38736769227')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ea2b7a5f-5f1e-4aa0-baa8-af206ed4f4dd', N'Abigaíl', N'Bravo', CAST(N'2004-07-15' AS Date), N'6995826107', N'27C89018-0534-480C-B719-5498EEE22D77', N'87076', N'34605045399')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ea2ea57b-ff53-44c1-95d2-72ba70061027', N'Sebastián', N'Montero', CAST(N'2007-05-31' AS Date), N'5356403175', N'5526D776-861B-4085-9B5F-91D58221D161', N'08218', N'39880911948')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ea4f693a-f006-4af8-9d08-16726873a503', N'Ariadna', N'Dominguez', CAST(N'2005-01-14' AS Date), N'3868689843', N'27C89018-0534-480C-B719-5498EEE22D77', N'20741', N'39918406275')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ea6da533-7227-44fb-aa15-21023f9363d8', N'Pascuala', N'Marcos', CAST(N'2010-01-15' AS Date), N'6155686793', N'5526D776-861B-4085-9B5F-91D58221D161', N'31387', N'33719878870')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ea8bfe56-5416-4fe0-a964-d6f24210b0d9', N'Paula', N'Guerrero', CAST(N'2018-10-23' AS Date), N'8212745750', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'04810', N'34814697349')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'eabdf15b-6b8f-4aa4-84a1-443ec1474317', N'Diego', N'Garcia', CAST(N'2013-07-16' AS Date), N'6689331230', N'5526D776-861B-4085-9B5F-91D58221D161', N'74058', N'37609028549')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'eae57e0f-6ed3-4387-a880-3b3b9157fe86', N'Marcela', N'Nieto', CAST(N'2016-09-22' AS Date), N'0104612070', N'27C89018-0534-480C-B719-5498EEE22D77', N'08617', N'38172812807')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'eb1ce602-8ab4-402e-b065-637436d412b6', N'Fabricia', N'Herrera', CAST(N'2005-12-20' AS Date), N'4353521881', N'27C89018-0534-480C-B719-5498EEE22D77', N'48801', N'38250314775')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'eb21e5f7-0930-4434-b340-a19c0a99ba1d', N'Xaverius', N'Diez', CAST(N'2009-11-04' AS Date), N'9162723145', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'73259', N'33742327659')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'eb3236a4-e2c7-45bf-afea-50f793ae8948', N'Alejandro', N'Ortiz', CAST(N'2021-07-18' AS Date), N'8830797585', N'5526D776-861B-4085-9B5F-91D58221D161', N'94318', N'31196303209')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'eb5a7d8b-7c17-4e02-9c18-00bbf1c61c08', N'Lía', N'Leon', CAST(N'2012-11-09' AS Date), N'9539609637', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'27398', N'39830215032')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'eb5ebbd8-4cb3-4c7d-84eb-1844dd929ab1', N'Malvolio', N'Santos', CAST(N'2007-10-07' AS Date), N'4162915019', N'27C89018-0534-480C-B719-5498EEE22D77', N'77737', N'30582429860')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'eb6f92b9-b5cf-4ee8-839d-49135ea8dcd6', N'Josué', N'Marin', CAST(N'2016-07-20' AS Date), N'4022353896', N'5526D776-861B-4085-9B5F-91D58221D161', N'67380', N'38635678826')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'eb9a0f48-ebb6-4adc-bd36-0885aee3580b', N'Lola', N'Calvo', CAST(N'2016-03-05' AS Date), N'6651616261', N'27C89018-0534-480C-B719-5498EEE22D77', N'82502', N'31132110631')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ebd6759c-990b-440f-91fa-759d4b3163d8', N'Lisandro', N'Torres', CAST(N'2010-04-03' AS Date), N'6117247862', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'27697', N'39654093885')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ebdcc493-819f-474b-ac22-55e55e35bbbf', N'Irene', N'Montero', CAST(N'2010-08-08' AS Date), N'3510992332', N'5526D776-861B-4085-9B5F-91D58221D161', N'54380', N'33044388326')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ebdff9e8-4b18-484d-8886-def385dfdd8b', N'Alodia', N'Hernandez', CAST(N'2014-11-09' AS Date), N'7617388182', N'5526D776-861B-4085-9B5F-91D58221D161', N'63159', N'31597195154')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ebf733f3-04a0-446a-86aa-cd198c02d1ff', N'Gael', N'Delgado', CAST(N'2021-02-23' AS Date), N'4676378513', N'5526D776-861B-4085-9B5F-91D58221D161', N'74160', N'35327053638')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ebf80c8b-119a-45fb-8124-9e7fa2d68071', N'Gloria', N'Ibanez', CAST(N'2003-08-03' AS Date), N'7198202230', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'88398', N'35519677572')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ec597a64-b96b-4d64-8605-e3fead3d0ea7', N'Dayana', N'Aguilar', CAST(N'2020-09-04' AS Date), N'1583681879', N'5526D776-861B-4085-9B5F-91D58221D161', N'53905', N'30904026263')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ec6bb301-c046-44ea-a0e6-61d4250c68e1', N'Jesusa', N'Caballero', CAST(N'2008-04-11' AS Date), N'5332455386', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'94064', N'33944397969')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ec78c963-d721-485e-a15c-d3ea6d61a339', N'Raimunda', N'Rodriguez', CAST(N'2003-02-21' AS Date), N'5695906448', N'27C89018-0534-480C-B719-5498EEE22D77', N'68375', N'31431670984')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ec834da0-fb69-4b43-b5d1-a167262b0cc7', N'Jerónimo/Gerónimo', N'Castro', CAST(N'2006-10-26' AS Date), N'1998155803', N'5526D776-861B-4085-9B5F-91D58221D161', N'96143', N'36342659603')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ec8d8eb6-bd81-468f-8a5c-966f17eb561e', N'Fabiana', N'Marquez', CAST(N'2013-11-30' AS Date), N'7478588107', N'5526D776-861B-4085-9B5F-91D58221D161', N'09201', N'30878600318')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ecc4d282-cea2-4f6c-9a35-cdb57ee03840', N'Malvolio', N'Jimenez', CAST(N'2008-10-17' AS Date), N'4520705574', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'23385', N'38046894939')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ecfb152b-67cc-4e23-85e7-054e0de95309', N'Thiago', N'Herrera', CAST(N'2010-11-30' AS Date), N'4353643531', N'27C89018-0534-480C-B719-5498EEE22D77', N'87541', N'36604855712')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ed31d946-c6d5-47b6-b041-88cbccde4035', N'Maximiliano', N'Blanco', CAST(N'2005-12-29' AS Date), N'0425020565', N'5526D776-861B-4085-9B5F-91D58221D161', N'05057', N'31912848186')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ed3741d5-a53e-44b3-87dc-eecfbcdb7b43', N'Eneko', N'Lorenzo', CAST(N'2020-10-09' AS Date), N'6556889321', N'27C89018-0534-480C-B719-5498EEE22D77', N'81326', N'37181774028')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ed7c2d7e-84fe-49d8-b4ec-cb8e6c763559', N'Marc', N'Munoz', CAST(N'2021-10-23' AS Date), N'8245322251', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'88842', N'34176428202')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ed894ffa-9bf6-4320-ae68-e17e8cf16085', N'Elena', N'Hidalgo', CAST(N'2013-03-20' AS Date), N'1762067641', N'5526D776-861B-4085-9B5F-91D58221D161', N'67907', N'36908002553')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'edb287b3-abd5-45fc-a075-8af4ad1637f6', N'Anita', N'Garrido', CAST(N'2015-07-28' AS Date), N'2108784988', N'27C89018-0534-480C-B719-5498EEE22D77', N'80589', N'31878682655')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ee2d3ef5-262c-43a8-acbf-4348b674a4fe', N'Christopher', N'Fuentes', CAST(N'2016-11-29' AS Date), N'5019565014', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'16630', N'36177986583')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ee589da2-7bec-4641-8cc7-77308f15af53', N'Ginebra', N'Ortega', CAST(N'2005-12-22' AS Date), N'6710550276', N'5526D776-861B-4085-9B5F-91D58221D161', N'57701', N'38279004539')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ee8aff01-e64e-4267-8766-dfb9baa6dbb3', N'Caleb', N'Hidalgo', CAST(N'2018-08-21' AS Date), N'9142489022', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'19526', N'35198700125')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'eec9911c-ee2b-422d-85df-0a80f365af4c', N'Kevin', N'Hidalgo', CAST(N'2018-02-19' AS Date), N'5983584132', N'27C89018-0534-480C-B719-5498EEE22D77', N'27731', N'38678968107')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'eeedb095-46a2-44f5-9059-e2f54a45ce9c', N'Rosario', N'Molina', CAST(N'2012-12-26' AS Date), N'1154101940', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'76188', N'35306107094')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ef0fb224-d85c-4c06-bee7-944fcd1aa642', N'Dominga', N'Campos', CAST(N'2006-01-21' AS Date), N'9473446313', N'5526D776-861B-4085-9B5F-91D58221D161', N'12006', N'38842093186')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ef5afb39-1f8f-4887-8e6d-6c5d4d06f7d6', N'Altagracia', N'Martin', CAST(N'2000-09-19' AS Date), N'3769950528', N'5526D776-861B-4085-9B5F-91D58221D161', N'16654', N'37877932133')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ef7a6f91-4874-45b6-9e91-013ada889f89', N'Pepe', N'Gimenez', CAST(N'2015-02-11' AS Date), N'9767252817', N'27C89018-0534-480C-B719-5498EEE22D77', N'05577', N'31435432607')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ef7af186-6302-4407-a7ef-de635fa75583', N'Lali', N'Rubio', CAST(N'2015-07-29' AS Date), N'7201244167', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'58476', N'30297533935')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f066f9b7-788e-4a1a-8f13-07bf5991372a', N'Macarena', N'Soto', CAST(N'2018-02-08' AS Date), N'1787030322', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'64391', N'36641020098')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f0ada7ce-b5e1-4403-9aa0-7b88ac56969a', N'Inés', N'Diaz', CAST(N'2000-03-23' AS Date), N'6832662005', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'49290', N'33826540824')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f0ddab05-e0f6-4e39-924a-2c62868ca7fa', N'Flavia', N'Cano', CAST(N'2008-02-29' AS Date), N'6197480208', N'5526D776-861B-4085-9B5F-91D58221D161', N'95579', N'35129065920')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f0ffe33c-68bc-4233-ad9b-87479d94c1dc', N'Juan Felipe', N'Guerrero', CAST(N'2011-07-13' AS Date), N'6715310307', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'14443', N'37011930980')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f0fff5df-aebc-4e4c-94d7-028dbe28f9dc', N'Max', N'Martin', CAST(N'2001-10-08' AS Date), N'5560267571', N'5526D776-861B-4085-9B5F-91D58221D161', N'95299', N'33088860869')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f12e8ece-06d9-4401-b84e-bc763f5269e9', N'Jon', N'Ibanez', CAST(N'2000-03-27' AS Date), N'3532345882', N'5526D776-861B-4085-9B5F-91D58221D161', N'56047', N'33346443495')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f189b1fe-d9c8-4588-b1d6-29e00bc54106', N'Ascensión', N'Caballero', CAST(N'2015-10-03' AS Date), N'2321021670', N'5526D776-861B-4085-9B5F-91D58221D161', N'03942', N'35448406214')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f19e406d-722b-4af3-8c61-9e9e6c24a3b9', N'Joaquin', N'Campos', CAST(N'2015-05-15' AS Date), N'8218937571', N'5526D776-861B-4085-9B5F-91D58221D161', N'50845', N'30189694672')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f2111b0e-ab13-442e-97df-6a6cc0264832', N'Aida', N'Sanchez', CAST(N'2005-05-04' AS Date), N'2055773176', N'5526D776-861B-4085-9B5F-91D58221D161', N'97022', N'39733588530')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f2597501-5336-4b1f-948c-c5502535f527', N'Marcos', N'Cruz', CAST(N'2008-11-10' AS Date), N'5972455299', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'15702', N'38039230005')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f276e933-eb08-4d2a-8892-4e1f380822cc', N'Diego', N'Arias', CAST(N'2015-05-09' AS Date), N'1093397217', N'27C89018-0534-480C-B719-5498EEE22D77', N'46360', N'31378967882')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f2844a16-1d87-4006-b31b-c9f2f28fe09f', N'Fulberta', N'Mora', CAST(N'2002-12-30' AS Date), N'4119841463', N'5526D776-861B-4085-9B5F-91D58221D161', N'57260', N'37327811989')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f35492e5-fd4a-4cac-b61e-eb9a7f2244be', N'María Magdalena', N'Ruiz', CAST(N'2006-12-18' AS Date), N'9883477389', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'37898', N'34011777842')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f366a073-0ac8-472c-9ce9-928ec9245552', N'adrian', N'Gonzalez', CAST(N'2017-08-25' AS Date), N'7757270425', N'27C89018-0534-480C-B719-5498EEE22D77', N'34746', N'32224379446')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f3bf80c3-2806-4c64-a2c8-07696c26989a', N'Simón', N'Ferrer', CAST(N'2007-08-18' AS Date), N'6763843566', N'27C89018-0534-480C-B719-5498EEE22D77', N'83174', N'34228200307')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f3d95449-3904-4b4f-82e4-006a96eeaea4', N'Anita', N'Menendez', CAST(N'2005-01-25' AS Date), N'6051846010', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'44227', N'34801047054')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f40ef318-8f17-43ca-80bf-b45f6d68fa08', N'Juan Diego', N'Alonso', CAST(N'2007-03-13' AS Date), N'6029012696', N'27C89018-0534-480C-B719-5498EEE22D77', N'33033', N'39704494228')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f41188c2-0439-4057-af54-5b6360a4eeba', N'Ismael', N'Lorenzo', CAST(N'2020-04-09' AS Date), N'2556946732', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'54895', N'38897525936')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f4474ec9-0164-4b41-9612-241eb9e8f830', N'adrian', N'Bravo', CAST(N'2013-09-15' AS Date), N'6861294486', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'73668', N'30693594753')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f457de3b-55be-4c72-8c9c-d3955364a3cb', N'Mónica', N'Leon', CAST(N'2009-07-10' AS Date), N'6689069367', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'38526', N'36673310477')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f4690bfb-f280-4c56-a8d8-8c0e0c4e5cb0', N'Lucía', N'Vila', CAST(N'2020-03-19' AS Date), N'7012390132', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'34953', N'36053752241')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f4853aac-4d9c-4482-9f74-c62afa460335', N'Andy', N'Ferrer', CAST(N'2004-12-12' AS Date), N'3983054206', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'59024', N'32582707798')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f4aa0a44-fdb3-41c0-a25d-c02e4122690f', N'Jesús', N'Alvarez', CAST(N'2007-02-28' AS Date), N'6776285985', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'51456', N'37559446802')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f4d33ece-e40c-4da4-9a7b-fd7afad4e1bb', N'Esteban', N'Duran', CAST(N'2006-06-07' AS Date), N'2823086267', N'5526D776-861B-4085-9B5F-91D58221D161', N'80678', N'39515833467')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f4de256d-2e76-47f8-a0f0-f5315b1ad269', N'Juan Pablo', N'Fernandez', CAST(N'2014-09-25' AS Date), N'9083961043', N'27C89018-0534-480C-B719-5498EEE22D77', N'30663', N'36587238635')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f4e0d775-2cef-48e5-8adb-450bc871b45e', N'Fraco', N'Sanchez', CAST(N'2007-06-06' AS Date), N'4812884685', N'27C89018-0534-480C-B719-5498EEE22D77', N'90454', N'35562326783')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f4e104e9-f13f-4aac-8cb8-cdc35653b10a', N'Emiliano', N'Sanz', CAST(N'2010-06-08' AS Date), N'7268943696', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'73188', N'32459427876')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f5067341-f11b-4174-94d9-793fb3c58711', N'Ricardo', N'Ibanez', CAST(N'2021-02-14' AS Date), N'3769062307', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'87178', N'37604259643')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f5661191-682c-43f8-8e6d-1545eb3f7e28', N'Axel', N'Hernandez', CAST(N'2019-06-09' AS Date), N'2663293441', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'42261', N'30238615712')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f57978b4-1269-471f-bbc9-ed6a26a6c1d9', N'Silvia', N'Hernandez', CAST(N'2021-03-13' AS Date), N'2897099258', N'5526D776-861B-4085-9B5F-91D58221D161', N'18399', N'34077250203')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f5905ae6-58a5-4867-98df-54219092c860', N'guille', N'Pena', CAST(N'2013-06-21' AS Date), N'3843528144', N'5526D776-861B-4085-9B5F-91D58221D161', N'95022', N'35196121736')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f59dce01-a048-4f6f-910e-53e6ac4d8b96', N'Paul', N'Ramos', CAST(N'2017-08-14' AS Date), N'0562127746', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'82657', N'35617103551')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f5c04873-4e2a-48ca-b2f6-81206b678c8d', N'Alodia', N'Jimenez', CAST(N'2019-03-04' AS Date), N'7741489094', N'27C89018-0534-480C-B719-5498EEE22D77', N'03741', N'35002041911')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f5f179c6-d82d-472f-ac01-fa075211c644', N'Zenon', N'Gil', CAST(N'2007-02-26' AS Date), N'9474535259', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'68525', N'31574810720')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f613ee3c-9310-4fad-a30b-ca59b0177ee1', N'Cristóbal', N'Pardo', CAST(N'2000-09-24' AS Date), N'5955891118', N'27C89018-0534-480C-B719-5498EEE22D77', N'86932', N'30106228943')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f61c83f7-eaed-4951-bab7-131da27ad0e4', N'Concha', N'Merino', CAST(N'2014-07-31' AS Date), N'5604945881', N'27C89018-0534-480C-B719-5498EEE22D77', N'84648', N'32692325976')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f620afa0-de6c-49e8-ba26-1cbe4db64a55', N'Evita', N'Prieto', CAST(N'2021-10-12' AS Date), N'2848445511', N'5526D776-861B-4085-9B5F-91D58221D161', N'37429', N'37989325102')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f65378d6-b05a-41e9-a999-987f00c67a59', N'Angélica', N'Gonzalez', CAST(N'2005-10-14' AS Date), N'9293620094', N'27C89018-0534-480C-B719-5498EEE22D77', N'47897', N'33047594821')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f65f2deb-657f-4949-8962-9f93efd0800f', N'Felisa', N'Navarro', CAST(N'2008-09-14' AS Date), N'3240805826', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'54785', N'38331111465')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f6853c45-46b1-4c26-aaf5-ffede339773b', N'Concha', N'Ibanez', CAST(N'2002-02-23' AS Date), N'6324302308', N'5526D776-861B-4085-9B5F-91D58221D161', N'44818', N'36653433444')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f6b55a19-28f5-4ecc-b6df-0e189bfb983d', N'Francisco', N'Mendez', CAST(N'2004-06-21' AS Date), N'2272732689', N'5526D776-861B-4085-9B5F-91D58221D161', N'48701', N'33531204290')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f6b62667-e59c-462f-94d8-71fb03b3fc53', N'Rut', N'Marcos', CAST(N'2006-01-11' AS Date), N'5149032533', N'5526D776-861B-4085-9B5F-91D58221D161', N'37783', N'34425804539')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f72a5a75-a83b-4710-9449-6587b89e791d', N'Ana', N'Iglesias', CAST(N'2007-12-20' AS Date), N'4516087804', N'27C89018-0534-480C-B719-5498EEE22D77', N'07502', N'37925677948')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f73770a4-bdcc-4648-809b-4532f4dab246', N'Lisandro', N'Moya', CAST(N'2018-01-19' AS Date), N'6050375593', N'27C89018-0534-480C-B719-5498EEE22D77', N'89249', N'38481112687')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f79eb974-c8ca-43f9-b8f6-5523b694d2b0', N'Inma', N'Soler', CAST(N'2016-07-25' AS Date), N'3351332486', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'76437', N'39362133017')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f7bcc05f-f1b7-4c2c-8340-bbd1b002e89c', N'Simón', N'Moya', CAST(N'2021-10-22' AS Date), N'8529590996', N'27C89018-0534-480C-B719-5498EEE22D77', N'35667', N'33561222016')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f7d0f9ab-5c77-43ff-8e8e-3a4dba5228ba', N'Juan Pablo', N'Bravo', CAST(N'2001-08-29' AS Date), N'0307426290', N'27C89018-0534-480C-B719-5498EEE22D77', N'02457', N'35138398967')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f8417c21-6d30-412c-bacb-a1b7c069d3fd', N'Gabriel', N'Moya', CAST(N'2005-07-21' AS Date), N'1456083503', N'27C89018-0534-480C-B719-5498EEE22D77', N'69133', N'36238166194')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f8563dad-0215-45d9-9c65-14c32408d5e1', N'Filomena', N'Arias', CAST(N'2001-02-08' AS Date), N'4674699539', N'5526D776-861B-4085-9B5F-91D58221D161', N'64177', N'31063063590')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f899c708-a6dd-4997-93f9-9ecec2cece70', N'Juan Pablo', N'Herrero', CAST(N'2014-04-01' AS Date), N'9587861253', N'27C89018-0534-480C-B719-5498EEE22D77', N'59585', N'32070101143')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f8ab24b4-aee5-45b8-9f4a-e940b8f5cf7e', N'Bea', N'Campos', CAST(N'2002-04-15' AS Date), N'6445077855', N'27C89018-0534-480C-B719-5498EEE22D77', N'77090', N'30156736597')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f8f19ab7-e7cc-45e6-ab66-b37df18850a8', N'Guillermina', N'Campos', CAST(N'2002-06-24' AS Date), N'8293154646', N'5526D776-861B-4085-9B5F-91D58221D161', N'27578', N'33594964067')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f915e42c-b7fd-4dc9-825f-708db2440b2e', N'Federico', N'Castro', CAST(N'2000-09-25' AS Date), N'8143444960', N'27C89018-0534-480C-B719-5498EEE22D77', N'70468', N'36613100723')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f92a47e4-b871-4489-983b-5fe550b536b7', N'Martina', N'Roman', CAST(N'2018-02-28' AS Date), N'8898039534', N'27C89018-0534-480C-B719-5498EEE22D77', N'26947', N'32179679129')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f95d0c43-79e0-4771-adfe-1891541d45c6', N'Mila', N'Soto', CAST(N'2000-03-12' AS Date), N'0365391444', N'27C89018-0534-480C-B719-5498EEE22D77', N'00458', N'34804303801')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f9a99818-3634-48f7-8e77-e067dcf14aaa', N'Inma', N'Duran', CAST(N'2002-08-07' AS Date), N'6357825620', N'5526D776-861B-4085-9B5F-91D58221D161', N'94684', N'35897412410')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f9ca7406-729b-4771-9a7b-3bfea1de8396', N'Thiago', N'Cortes', CAST(N'2010-04-10' AS Date), N'1211770454', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'63045', N'32646265388')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'f9eca861-001b-4093-934b-9265cdc0688d', N'Fraco', N'Santos', CAST(N'2010-10-07' AS Date), N'6173299957', N'27C89018-0534-480C-B719-5498EEE22D77', N'56930', N'31066005890')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fa099d5c-662a-42c0-9775-afecb8c8583e', N'Modesta', N'Hernandez', CAST(N'2004-05-27' AS Date), N'6325645044', N'5526D776-861B-4085-9B5F-91D58221D161', N'41976', N'34122341850')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fa17add9-8126-45d2-aa57-3ed48fbff56d', N'Miguel Ángel', N'Martin', CAST(N'2020-11-12' AS Date), N'5109386322', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'62664', N'31873108574')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fa1f248f-1d93-4d1d-b1d3-43d5bfeaffcb', N'Itahisa', N'Martin', CAST(N'2002-07-05' AS Date), N'5344174202', N'5526D776-861B-4085-9B5F-91D58221D161', N'95401', N'38675881207')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fa2d88cc-b645-47a7-8fec-28670b56869a', N'Marcela', N'Bravo', CAST(N'2013-04-12' AS Date), N'1579062058', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'90412', N'32264938096')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fa6c7dfc-8b8a-484b-a6c7-e9fe7d479150', N'Blanca', N'Ramirez', CAST(N'2020-09-01' AS Date), N'9837786666', N'5526D776-861B-4085-9B5F-91D58221D161', N'04870', N'38385793071')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fa8549f4-72ad-430d-a6bc-3bc3e6691611', N'Macario', N'Iglesias', CAST(N'2014-05-18' AS Date), N'3980021389', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'64816', N'35166142759')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fa8abfa7-cd95-49b9-a4bf-adaa9cd49c13', N'Sofía', N'Suarez', CAST(N'2002-04-13' AS Date), N'2222784312', N'27C89018-0534-480C-B719-5498EEE22D77', N'76654', N'32163529257')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fa906668-afa7-4e42-b32a-c866f8d6a5cf', N'Felipa', N'Vila', CAST(N'2021-01-01' AS Date), N'8770290684', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'89833', N'30332773390')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fa9abc00-75c7-4394-b620-71d801f4c4d8', N'Iker', N'Marcos', CAST(N'2008-04-20' AS Date), N'8436428899', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'47294', N'31319204872')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fa9f5532-d641-4c7d-a8f1-43fa6eda5de5', N'Iker', N'Carmona', CAST(N'2009-10-12' AS Date), N'5983640449', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'66804', N'38327405655')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fb0e2eb1-2a4a-427b-b733-a669eab56ca6', N'Florencia', N'Ortiz', CAST(N'2011-11-22' AS Date), N'0367014835', N'27C89018-0534-480C-B719-5498EEE22D77', N'28573', N'35501102369')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fb25c87e-e959-4823-a7bd-ef9b6507150a', N'Dominga', N'Vega', CAST(N'2017-08-15' AS Date), N'7718096183', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'48459', N'32889705459')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fb43fa34-a61b-428f-83ed-52586adfef75', N'Elvira', N'Pena', CAST(N'2010-12-23' AS Date), N'6623813552', N'5526D776-861B-4085-9B5F-91D58221D161', N'72486', N'36946484731')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fbdfc873-96fb-4122-a3f8-65b6d7e827ff', N'Elvira', N'Cortes', CAST(N'2012-09-01' AS Date), N'7930261235', N'27C89018-0534-480C-B719-5498EEE22D77', N'11987', N'37725883092')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fbe33ae9-2c6a-44bb-b819-7fd277bbac9c', N'Jaime', N'Molina', CAST(N'2001-08-26' AS Date), N'3017119690', N'27C89018-0534-480C-B719-5498EEE22D77', N'93788', N'33425183555')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fc26ccf1-1c80-4fa9-a67e-0a718d452501', N'Alba', N'Castillo', CAST(N'2007-03-03' AS Date), N'0128201267', N'27C89018-0534-480C-B719-5498EEE22D77', N'68801', N'34447281079')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fc511e65-e1f8-4278-82f2-cd75a9aeedf2', N'Piedad', N'Dominguez', CAST(N'2001-02-14' AS Date), N'9233088732', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'91011', N'35526163429')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fc910498-ccfe-435a-9e9f-39d241e2db17', N'Mireia', N'Garcia', CAST(N'2011-04-15' AS Date), N'7430425257', N'27C89018-0534-480C-B719-5498EEE22D77', N'88144', N'36481329804')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fcc36212-1cf9-495a-a1aa-e49256bc00df', N'Camilo', N'Blanco', CAST(N'2000-10-29' AS Date), N'2798178038', N'27C89018-0534-480C-B719-5498EEE22D77', N'87301', N'34285722079')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fcd48a47-05fd-4fba-98d5-79a1ab829e7b', N'Patricia', N'Caballero', CAST(N'2011-08-30' AS Date), N'4258994670', N'27C89018-0534-480C-B719-5498EEE22D77', N'09395', N'33409731868')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fce67ee5-6530-4c2a-9c54-70f9a6d750fa', N'Matthew', N'Moreno', CAST(N'2008-07-30' AS Date), N'5399989386', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'33189', N'35626328892')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fd19c6f3-ea8c-4585-a3bf-0ac395362d76', N'Alejandro', N'Menendez', CAST(N'2017-03-01' AS Date), N'3216074003', N'27C89018-0534-480C-B719-5498EEE22D77', N'55079', N'35799259047')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fd23e4ea-7357-4e6a-a205-0f1d5bd5c2df', N'Arnau', N'Diaz', CAST(N'2014-09-30' AS Date), N'4399575565', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'42064', N'36101221692')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fd35ebd2-cfbd-4f8f-8a7e-6e44fe3101f7', N'Emilio', N'Fuentes', CAST(N'2000-09-08' AS Date), N'9119667367', N'5526D776-861B-4085-9B5F-91D58221D161', N'76634', N'35681677781')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fd49334e-e840-4d52-86df-c00728a0326c', N'Patricia', N'Moreno', CAST(N'2003-04-10' AS Date), N'0319322039', N'5526D776-861B-4085-9B5F-91D58221D161', N'98881', N'36113048138')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fd601732-39ba-4bbd-a20d-8087a13859be', N'África', N'Andres', CAST(N'2017-07-01' AS Date), N'3810034988', N'27C89018-0534-480C-B719-5498EEE22D77', N'10210', N'31088598070')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fd992020-724b-482a-927e-0e03d5f21f38', N'Lorenza', N'Vidal', CAST(N'2015-04-23' AS Date), N'9857247123', N'5526D776-861B-4085-9B5F-91D58221D161', N'52150', N'32754246894')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fda20341-e2ee-4b3b-afff-fc539ceeab41', N'Gervasio', N'Carmona', CAST(N'2017-10-24' AS Date), N'8408358850', N'5526D776-861B-4085-9B5F-91D58221D161', N'52519', N'39362097788')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fdc03245-704f-4480-be60-48cc14fca650', N'Beatriz', N'Bravo', CAST(N'2020-09-05' AS Date), N'4216350539', N'5526D776-861B-4085-9B5F-91D58221D161', N'09259', N'34303602661')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fdc2f908-1306-414e-ab7b-958701fc2aba', N'Angela', N'Soler', CAST(N'2012-07-04' AS Date), N'1043076277', N'5526D776-861B-4085-9B5F-91D58221D161', N'87297', N'37141137440')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fe0e72c5-3d9d-4d49-beb1-f16465e61a3d', N'Serafina', N'Jimenez', CAST(N'2015-11-22' AS Date), N'4307610253', N'27C89018-0534-480C-B719-5498EEE22D77', N'20452', N'35818265114')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fe2008b3-a92f-4983-bea1-0f331a1d0174', N'Luis', N'Hidalgo', CAST(N'2007-11-15' AS Date), N'7432815217', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'00080', N'39331452325')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fe236bc5-b3c7-4e91-a12f-d1800e824ffa', N'Fermina', N'Herrero', CAST(N'2019-11-25' AS Date), N'5272173619', N'5526D776-861B-4085-9B5F-91D58221D161', N'04675', N'32471447930')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'feca61e9-c1ba-4a4e-ad11-18390f1d3fe3', N'Xavier', N'Marquez', CAST(N'2001-09-15' AS Date), N'6782114866', N'27C89018-0534-480C-B719-5498EEE22D77', N'89388', N'32582785047')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ff0ad20b-8683-4d0d-9532-639836594ecb', N'Liliana', N'Carmona', CAST(N'2002-04-15' AS Date), N'4857534834', N'27C89018-0534-480C-B719-5498EEE22D77', N'81591', N'33638903381')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ff0cc41e-66ac-4a1c-92b9-9a269bf89e5e', N'Diego', N'Duran', CAST(N'2000-11-01' AS Date), N'4568313323', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'73364', N'37753217600')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ff2ff191-f09b-443f-a1ee-9a5f5bda4e8a', N'Ignacio', N'Sanchez', CAST(N'2017-09-26' AS Date), N'2650187345', N'5526D776-861B-4085-9B5F-91D58221D161', N'38575', N'34601919871')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ff4a5eef-0dd6-453c-ba5b-450498c79a7c', N'Eva', N'Marquez', CAST(N'2009-01-20' AS Date), N'3029111721', N'27C89018-0534-480C-B719-5498EEE22D77', N'74518', N'33391482878')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ff65271a-4141-42e6-872f-1254fd926203', N'Gara', N'Sanz', CAST(N'2003-11-07' AS Date), N'6987999010', N'27C89018-0534-480C-B719-5498EEE22D77', N'77814', N'30595711906')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ff719135-dc69-4c30-981e-377b46fbe00b', N'Nerea', N'Rey', CAST(N'2008-07-31' AS Date), N'6366709576', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'04379', N'32777029799')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ffdd2c4f-189e-4ee9-90ff-d90b84dee397', N'Adriana', N'Romero', CAST(N'2000-09-15' AS Date), N'9295057947', N'5526D776-861B-4085-9B5F-91D58221D161', N'26080', N'31461411653')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'ffede534-5cff-447d-8b0d-b0c07117fddc', N'Clotilde', N'Pascual', CAST(N'2019-03-15' AS Date), N'1202706651', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'02666', N'32437271863')
GO
INSERT [dbo].[clientes] ([id], [nombres], [apellidos], [nacimiento], [documento], [lugarNacimiento], [codigoPostal], [telefono]) VALUES (N'fff5bada-be8c-4a6f-938b-14f3e6d422ba', N'Fernanda', N'Ruiz', CAST(N'2018-07-29' AS Date), N'7574849341', N'4C2DFCB8-A052-4035-A2FE-E75C637BC64B', N'15163', N'33761945111')
GO
INSERT [dbo].[combustible] ([id], [descripcion], [codigo]) VALUES (N'177E6107-4183-4D0F-8D8A-15C04F654689', N'GASOLINA - GAS ', N'4')
GO
INSERT [dbo].[combustible] ([id], [descripcion], [codigo]) VALUES (N'1ACE3CFA-4990-4A15-A6A9-243A4A136A7A', N'ELECTRICO', N'5')
GO
INSERT [dbo].[combustible] ([id], [descripcion], [codigo]) VALUES (N'3D679166-4188-4405-B9FD-0F7E58299774', N'GAS NATURAL VEHICULAR (GNV)', N'3')
GO
INSERT [dbo].[combustible] ([id], [descripcion], [codigo]) VALUES (N'62583378-8E9C-4E79-96C8-4208F6ADBC84', N'GASOLINA', N'1')
GO
INSERT [dbo].[combustible] ([id], [descripcion], [codigo]) VALUES (N'667FAC5A-7E3C-429B-9FE0-B638B0A02A39', N'ETANOL', N'7')
GO
INSERT [dbo].[combustible] ([id], [descripcion], [codigo]) VALUES (N'95A06952-4FA1-42F6-A948-E170E4F0DC3C', N'HIDROGENO', N'6')
GO
INSERT [dbo].[combustible] ([id], [descripcion], [codigo]) VALUES (N'A4561CB5-BDDB-4F99-BDB8-ECE353D0373A', N'DIESEL', N'2')
GO
INSERT [dbo].[combustible] ([id], [descripcion], [codigo]) VALUES (N'B1B996A1-7100-4BE8-8728-CF7A83FF0EE4', N'BIODIESEL', N'8')
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'015AB46D-70CF-45ED-9FBF-1D5F07676611', N'Islas Georgias del Sur y Sandwich del Sur', N'GS', N'SGS', 500)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'045DD25C-5E6D-4667-B1ED-82F4F20F1693', N'Guadalupe', N'GP', N'GLP', 590)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'059B1226-B9B6-4CB7-9E96-E7E61E511AF9', N'San Cristóbal y Nieves', N'KN', N'KNA', 1869)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'05B6F736-14D6-4591-8610-909FC899D0DF', N'Bélgica', N'BE', N'BEL', 32)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'06AEA104-FEE0-4DF1-8C01-045B7D6561A5', N'Singapur', N'SG', N'SGP', 65)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'0782A67B-92CB-4040-907F-BB8D576209B7', N'Kiribati', N'KI', N'KIR', 686)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'078CF278-6844-4768-86E3-5110F57B8190', N'Dominica', N'DM', N'DMA', 1767)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'08EC6EAE-A07A-48BF-B2F8-9005D0701BE2', N'Guayana Francesa', N'GF', N'GUF', 594)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'09253293-12F4-49A2-B9F6-25287327DDAE', N'Bahamas', N'BS', N'BHS', 1242)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'093487B4-CBC2-4436-9509-03814C710CB0', N'Nauru', N'NR', N'NRU', 674)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'0948332D-68B2-426D-92F0-DEC19C27A949', N'Bosnia y Herzegovina', N'BA', N'BIH', 387)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'094C0812-EF17-41DE-8374-159C7FC996FD', N'Sint Maarten', N'SX', N'SMX', 1721)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'0A8F6FD2-9343-4DB6-9FAE-1DB4F574B3FE', N'Islas Vírgenes de los Estados Unidos', N'VI', N'VIR', 1340)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'0B556FE2-5219-48BC-AAFD-72F76481ECC5', N'Ghana', N'GH', N'GHA', 233)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'0C73BE13-53AA-411D-99A3-801D1D6930E1', N'Armenia', N'AM', N'ARM', 374)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'0EFEB9E9-1574-4AE1-BEB9-EA1A13809901', N'Niger', N'NE', N'NER', 227)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'120EB2FD-358E-47A6-8BAD-BE1ABC0CDACF', N'Islas de Åland', N'AX', N'ALA', 358)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'13566247-5EC9-43C4-86C6-30562D5206F1', N'Tailandia', N'TH', N'THA', 66)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'14390DD8-4180-442C-B6E5-E327EBFEA8BC', N'Nueva Zelanda', N'NZ', N'NZL', 64)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'148EA447-2655-4D4D-80E4-9A520555C85A', N'Chipre', N'CY', N'CYP', 357)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'14C666DF-C7E3-4C27-889F-D18CAE5409C6', N'Namibia', N'NA', N'NAM', 264)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'156FCD2E-A5D2-4AA2-832A-0AEAD1D2B2B4', N'Vietnam', N'VN', N'VNM', 84)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'15924663-9AAD-4895-B77E-24E663AFBDEB', N'Sri lanka', N'LK', N'LKA', 94)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'19D37D57-E459-4D31-813F-57403A55CD9D', N'Ruanda', N'RW', N'RWA', 250)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'1A10A31D-3B57-4F7D-A8A4-DAE4EA03BBC8', N'Senegal', N'SN', N'SEN', 221)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'1A3A4DC8-CB3F-4D9B-8174-CD8B659EC2CF', N'Curazao', N'CW', N'CWU', 5999)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'1E5D263B-446D-49E9-8EF7-09EB389509F2', N'Mayotte', N'YT', N'MYT', 262)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'1E72C713-D039-4701-85DF-9EE157FF9083', N'Islas Maldivas', N'MV', N'MDV', 960)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'1F1A5015-25F4-46B2-BFA3-6B404D571C76', N'Comoras', N'KM', N'COM', 269)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'207C0841-5D91-42F5-8E61-5C7526C846C1', N'Niue', N'NU', N'NIU', 683)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'20DC5AD5-1FCD-4D2D-BEDB-B2D3A9F2920D', N'Bahrein', N'BH', N'BHR', 973)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'217B2030-604C-4C9B-A7B3-9D2FBF4DC38D', N'Islas Marianas del Norte', N'MP', N'MNP', 1670)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'21F5C458-48CE-45C9-8DF9-51CB0899611E', N'Granada', N'GD', N'GRD', 1473)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'227D9CA5-C13E-4FE2-9FD9-CD49C62F5BE1', N'Ciudad del Vaticano', N'VA', N'VAT', 39)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'240B5C5D-E060-4196-8FB1-7C79061CD622', N'Mozambique', N'MZ', N'MOZ', 258)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'24BDBE95-C442-4F49-A4EF-114CA5A2C855', N'Israel', N'IL', N'ISR', 972)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'24F6C322-613D-4373-8A00-6DAD1927DCF0', N'Rumanía', N'RO', N'ROU', 40)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'2504F9D4-572C-49A3-87FD-412950A12C66', N'Reunión', N'RE', N'REU', 262)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'258622B6-3672-4316-8E7C-6E36D86F6F14', N'Mongolia', N'MN', N'MNG', 976)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'25EEB041-4491-42FB-916A-0EF2EEE484BC', N'Pakistán', N'PK', N'PAK', 92)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'25F94DA0-94DF-4D21-8018-EEE0CE367FDB', N'Rusia', N'RU', N'RUS', 7)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'26D96D75-4707-4762-9CD4-86351DBF73EC', N'Vanuatu', N'VU', N'VUT', 678)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'2835109F-88DC-4A81-9605-EC37304F479C', N'Hungría', N'HU', N'HUN', 36)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'2847302B-CB39-4A0F-A7EE-42E91AB262AF', N'Burundi', N'BI', N'BDI', 257)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'28A1302A-3F71-4779-B63C-B5ADCC9384F5', N'Jersey', N'JE', N'JEY', 44)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'28C6E1DB-E6BF-4198-94E3-26B662D8FA87', N'República del Congo', N'CG', N'COG', 242)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'28DA1915-C89D-47B2-AADE-981F4BE4002B', N'República Checa', N'CZ', N'CZE', 420)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'29733B8D-A0C2-423A-9D25-20DB1AADAC20', N'Samoa', N'WS', N'WSM', 685)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'2C288A8A-CCAA-4D16-B3FB-18893F3503FE', N'Togo', N'TG', N'TGO', 228)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'2CD5D721-5D45-4CAF-B1F6-63DD21A21301', N'Marruecos', N'MA', N'MAR', 212)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'2ED1BB74-8E57-4B83-914B-61ABEF7D64AB', N'Omán', N'OM', N'OMN', 968)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'2FDB2D90-1F11-4449-B2AA-A33E8D1C8F98', N'Jordania', N'JO', N'JOR', 962)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'2FFD1F13-988A-443D-995D-F264C51BC07C', N'Nepal', N'NP', N'NPL', 977)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'31F8A1D5-A33D-424F-A2E3-7C5B4B4EC43B', N'Perú', N'PE', N'PER', 51)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'321F83EC-F9C2-448F-8831-942B5738C895', N'Laos', N'LA', N'LAO', 856)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'32B5E150-5B71-4C83-BC5B-70816C1F9BAE', N'Eritrea', N'ER', N'ERI', 291)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'33E52141-941A-4F26-8967-86CA48A96712', N'Uzbekistán', N'UZ', N'UZB', 998)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'3772C0F1-89F9-41F5-9835-4BF59B81994E', N'Qatar', N'QA', N'QAT', 974)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'381D4C78-A03E-4DAB-BF4B-111A609BBE15', N'Egipto', N'EG', N'EGY', 20)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'38610608-D511-4747-9A77-6F2BAAF2C80D', N'Macao', N'MO', N'MAC', 853)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'39271FCB-A143-4C23-91F7-1E7C6292B132', N'Tokelau', N'TK', N'TKL', 690)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'39E19B91-8247-4164-9E1A-4705F7D7523A', N'Liechtenstein', N'LI', N'LIE', 423)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'3A1EB012-CD54-4709-BCB8-A39A60AA0B50', N'Argentina', N'AR', N'ARG', 54)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'3A5A2394-D4EF-4902-AFA0-328A30B31AE8', N'Croacia', N'HR', N'HRV', 385)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'3B6A1FFA-9A3F-44B6-9A22-C611E49465D8', N'Martinica', N'MQ', N'MTQ', 596)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'3C234F2B-239A-442C-9B27-7AFD0BC95F0F', N'Líbano', N'LB', N'LBN', 961)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'435223B2-999B-4DB9-9A42-F38F566DF467', N'Macedônia', N'MK', N'MKD', 389)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'440ED0A7-6F12-40AE-93AD-635998A7C826', N'Gabón', N'GA', N'GAB', 241)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'45EF2E61-0314-4C4D-B087-8E26D4F72B20', N'Palestina', N'PS', N'PSE', 970)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'4714246B-FA17-4721-8739-2C4EE47BDF5F', N'Barbados', N'BB', N'BRB', 1246)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'47CBE915-F514-4745-A0D6-AC5C176C51E5', N'Swazilandia', N'SZ', N'SWZ', 268)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'483CDF30-488B-4B47-993C-02FA8CEC9DB6', N'Francia', N'FR', N'FRA', 33)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'486ED817-8E10-436A-96F0-34C9A97A938D', N'Islas Malvinas', N'FK', N'FLK', 500)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'48E7ACA3-E985-4ABA-B82A-0254A0570BC8', N'Guinea-Bissau', N'GW', N'GNB', 245)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'490CD1D6-BC57-4B5C-B2E7-2B68E6938400', N'Italia', N'IT', N'ITA', 39)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'499BDC50-CD20-43A8-AB0F-7EB6220E22E9', N'Yibuti', N'DJ', N'DJI', 253)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'4E426FCC-A0C0-4736-86B5-2F69B13A5D42', N'Guernsey', N'GG', N'GGY', 44)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'523F23CF-E274-43E0-8529-DF5D7652FFA3', N'San Pedro y Miquelón', N'PM', N'SPM', 508)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'5243AB10-3D55-486F-AFC9-93C752270BEC', N'Lesoto', N'LS', N'LSO', 266)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'568B1DD4-4FA7-40AE-AC04-E46981CE15DD', N'Timor Oriental', N'TL', N'TLS', 670)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'599D0B63-3672-42A5-A0A9-1668AF6FA456', N'Santa Lucía', N'LC', N'LCA', 1758)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'5BF8D7FE-655F-46B6-9A4C-3550BCAF9B0D', N'Islas Marshall', N'MH', N'MHL', 692)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'5C271CA3-0841-4F22-949C-7B8A5BCEB9B3', N'República Democrática del Congo', N'CD', N'COD', 243)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'5D2D4315-4E72-4B09-B411-3B17420832A7', N'Samoa Americana', N'AS', N'ASM', 1684)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'5D78F83A-6006-4D82-9F24-C1CA0D7EF0D6', N'Guyana', N'GY', N'GUY', 592)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'620DB2E8-CFD8-4343-9366-365C5261B9A8', N'China', N'CN', N'CHN', 86)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'62E9BF36-8342-469C-86D1-1C87F3A571AC', N'Islas Caimán', N'KY', N'CYM', 1345)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'63A21387-224B-4AB9-8265-0AC0A0F2E023', N'Australia', N'AU', N'AUS', 61)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'647EC88B-50BB-4844-B077-CDA6ADB835EB', N'Sahara Occidental', N'EH', N'ESH', 212)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'64F71E1B-3404-4D2A-81BF-6C4A93E16997', N'Georgia', N'GE', N'GEO', 995)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'65D38E92-5A73-4B73-833B-40663D98FC76', N'Irán', N'IR', N'IRN', 98)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'67151BEF-CABD-4148-BAD6-64A43F226DB8', N'Libia', N'LY', N'LBY', 218)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'678D1AE6-02A7-48A0-B1EA-757E24A79B40', N'Nigeria', N'NG', N'NGA', 234)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'67A73DCD-276D-4FEF-9294-2B1D9FDE9E70', N'Mónaco', N'MC', N'MCO', 377)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'69D2DDF5-2652-49E1-8933-62EEBD2F3344', N'Guam', N'GU', N'GUM', 1671)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'69E0FEFB-2CBC-4EA7-A0AC-5DD95A5211FA', N'Isla Norfolk', N'NF', N'NFK', 672)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'6A6AA299-6B04-436F-9BAB-FC0C335EC7BD', N'Trinidad y Tobago', N'TT', N'TTO', 1868)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'6AE861F0-91B4-4799-B234-6E1837E74366', N'Isla Bouvet', N'BV', N'BVT', 0)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'6B4501CB-6BFA-401F-A47E-340EF1E2D61C', N'Irlanda', N'IE', N'IRL', 353)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'6DAE3D4A-6D38-4998-BC0B-FBCF8513ED97', N'Birmania', N'MM', N'MMR', 95)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'6F1CE61B-5F55-4151-9684-6AC3EC8D6080', N'Turquía', N'TR', N'TUR', 90)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'6FF78CD4-6B97-4977-9540-91C5BCBDD586', N'Somalia', N'SO', N'SOM', 252)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'708C0335-6B55-4B67-9A91-41B89103DBF9', N'Andorra', N'AD', N'AND', 376)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'71CFAA98-4FD0-4EF7-A4F8-A7181E51267C', N'Belice', N'BZ', N'BLZ', 501)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'7262BDBF-147E-4E52-933A-1A056909A745', N'Costa de Marfil', N'CI', N'CIV', 225)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'728C853E-F4F1-44B3-ABA1-3B318C00AF50', N'Nicaragua', N'NI', N'NIC', 505)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'748E44E7-DFC6-4942-A525-E668F9BCA771', N'Noruega', N'NO', N'NOR', 47)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'74ABAC55-EF19-4407-9A56-5FF66AC48AAA', N'Wallis y Futuna', N'WF', N'WLF', 681)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'74BA3F65-9B77-4C48-AB5C-B72C26AA61C1', N'Nueva Caledonia', N'NC', N'NCL', 687)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'7570881D-8DF7-44A6-83CD-68D636298708', N'Venezuela', N'VE', N'VEN', 58)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'757EDCF6-43DD-4299-A4BF-7400C1BB476D', N'Alemania', N'DE', N'DEU', 49)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'769F65DB-3396-4142-AF0B-2BEB859BD0F2', N'Etiopía', N'ET', N'ETH', 251)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'79A73AAB-CA85-4EEC-8E78-4EB5C2FFD201', N'Letonia', N'LV', N'LVA', 371)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'7A0AFF8C-C7B8-44D1-8A84-EB53BA279DD4', N'Taiwán', N'TW', N'TWN', 886)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'7A4E3694-7C66-4F7B-83F0-BCD8421BF92C', N'Tayikistán', N'TJ', N'TJK', 992)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'7CB150C2-CC7B-442D-A7DD-F659C8E9B11B', N'Emiratos Árabes Unidos', N'AE', N'ARE', 971)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'7D5994B4-EF69-4072-B53A-8ED0C700A074', N'Fiyi', N'FJ', N'FJI', 679)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'7E762FC6-2E57-4261-BF75-60BF70478C0E', N'El Salvador', N'SV', N'SLV', 503)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'7EE71976-4589-4881-A907-627ADFD1FB7A', N'República Centroafricana', N'CF', N'CAF', 236)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'7EE9D739-382C-4088-A4DC-E50B7550C3EF', N'Arabia Saudita', N'SA', N'SAU', 966)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'8300E2DC-5E46-4C7D-9C07-DE2E2106E2D1', N'Camerún', N'CM', N'CMR', 237)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'8421C83E-A003-463D-B420-3F2971883325', N'Suiza', N'CH', N'CHE', 41)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'856D60C3-EFD8-4E1C-B8B2-D1F23201FA8D', N'Aruba', N'AW', N'ABW', 297)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'85C4737C-43D8-4C05-9665-0EEAA6573D88', N'Chile', N'CL', N'CHL', 56)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'880DD1B3-7072-4423-912B-ADF309E1ED7B', N'Tuvalu', N'TV', N'TUV', 688)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'88250872-BB2F-47DE-A735-6E4FAFA80B1F', N'Mali', N'ML', N'MLI', 223)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'88701F9D-E65B-4777-A9F4-2A6F6797464B', N'Turkmenistán', N'TM', N'TKM', 993)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'88AA2483-6C4D-42A5-8844-E20740465757', N'Papúa Nueva Guinea', N'PG', N'PNG', 675)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'8A68C912-BCFA-4B5E-9295-3D2965F35085', N'Isla de Navidad', N'CX', N'CXR', 61)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'8B2ABF9C-B9F4-42F3-9F05-7C58E8E5C922', N'Seychelles', N'SC', N'SYC', 248)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'8B7216DF-9064-4139-B223-2D12FE656204', N'Isla de Man', N'IM', N'IMN', 44)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'8D740BE8-F8A3-4B1B-B46B-165A86E6306D', N'Serbia', N'RS', N'SRB', 381)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'8E05DA8F-64C9-42E5-A184-1335849C9315', N'Bolivia', N'BO', N'BOL', 591)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'8E53FF31-2797-442C-BA2A-D93DE52721AC', N'Ecuador', N'EC', N'ECU', 593)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'8E9C395D-E227-4354-A103-32A67AF14A08', N'Países Bajos', N'NL', N'NLD', 31)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'907CDEA5-5706-4918-9623-582A2B8189A0', N'Paraguay', N'PY', N'PRY', 595)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'90E06156-9011-4B0C-9E27-A41EC5C7ACEE', N'Benín', N'BJ', N'BEN', 229)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'90EDCEB8-DFD3-4256-A496-430708357F16', N'Islas Bermudas', N'BM', N'BMU', 1441)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'9186784F-543C-46AC-BB2A-461B3011E1DB', N'Canadá', N'CA', N'CAN', 1)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'91B0849C-65D1-4C5F-B6C4-E40224690570', N'Corea del Sur', N'KR', N'KOR', 82)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'927E7FAE-643B-46BE-83B3-8BB3C2D66EB1', N'Surinám', N'SR', N'SUR', 597)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'93CD6A34-90F5-4D79-A6ED-B6018A312662', N'Chad', N'TD', N'TCD', 235)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'93F1F45A-5F5A-49A8-913A-9490ABE9EE0E', N'Bangladesh', N'BD', N'BGD', 880)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'94BF99DF-0C60-4F2A-9B73-58748DCD7F09', N'Santa Elena', N'SH', N'SHN', 290)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'9534F9B1-9F6E-4A09-B8BB-A483598B931E', N'Indonesia', N'ID', N'IDN', 62)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'9697C7F0-9256-404A-ADB6-949081A0749C', N'Lituania', N'LT', N'LTU', 370)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'9AD9D84E-856E-4C93-8FD3-9C2D14CC7145', N'Montserrat', N'MS', N'MSR', 1664)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'9E409E80-7AF5-461F-8595-77C831BC5350', N'Islas Salomón', N'SB', N'SLB', 677)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'9FCFD5AB-53D7-456C-8950-8B9F92A0EF9B', N'Cuba', N'CU', N'CUB', 53)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'A08592B8-BB36-4C4A-B312-7DF5891E204D', N'Territorios Australes y Antárticas Franceses', N'TF', N'ATF', 0)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'A102D486-221A-42C1-A795-F5A48E289FC4', N'Guinea Ecuatorial', N'GQ', N'GNQ', 240)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'A18BEBDD-8232-4584-80C3-B6CC7CC2FCB4', N'Svalbard y Jan Mayen', N'SJ', N'SJM', 47)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'A1B58AD3-5CF7-4BCF-A4E8-4AFC9DDEB964', N'Territorio Británico del Océano Índico', N'IO', N'IOT', 246)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'A1FA9E13-3302-48E2-A3EB-C0F26E97FE46', N'Sierra Leona', N'SL', N'SLE', 232)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'A2010DBC-2BD6-4195-BAAF-C1453B548339', N'San Martín (Francia)', N'MF', N'MAF', 1599)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'A56436F1-02D5-4E00-94E2-A182C39D2F1C', N'Islas Ultramarinas Menores de Estados Unidos', N'UM', N'UMI', 246)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'A6B62888-2C2A-4D34-8662-F47270B55BF2', N'Kirguistán', N'KG', N'KGZ', 996)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'A7694DEE-A3F1-4544-8C63-27ABDABD0312', N'Afganistán', N'AF', N'AFG', 93)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'A7EA4238-FDBB-4400-86CE-002E644E7EFA', N'Tunez', N'TN', N'TUN', 216)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'A86AB843-7472-449B-A93F-9B89438DD0F2', N'Micronesia', N'FM', N'FSM', 691)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'A878F21A-5756-4A3D-872D-0DBEAE1C46E1', N'Afganistán', N'AF', N'AFG', 93)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'A8A3B33B-937F-48BA-B18E-6056C6BFCC12', N'Irak', N'IQ', N'IRQ', 964)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'A92890BF-D958-45CE-8865-EA4084CE913E', N'Kenia', N'KE', N'KEN', 254)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'AA6E7B6B-B22C-40C0-B253-F959F2D46B17', N'Haití', N'HT', N'HTI', 509)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'AC633C5C-BE0F-4146-8D2B-45BB696B5F76', N'Bulgaria', N'BG', N'BGR', 359)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'AE17326B-90A6-43A1-96A2-EF58E84FB2A0', N'Costa Rica', N'CR', N'CRI', 506)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'B0704087-7840-4F06-9EE1-C4FCDD5B2482', N'San Bartolomé', N'BL', N'BLM', 590)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'B0849695-2B67-414C-979F-AB27FE2E781F', N'Colombia', N'CO', N'COL', 57)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'B1089C85-9E9C-42DB-8863-F69D19199E69', N'Grecia', N'GR', N'GRC', 30)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'B23C7B17-7ABC-4408-88BB-E89929FD8296', N'Reino Unido', N'GB', N'GBR', 44)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'B35CC39E-DB44-49CC-A03B-D38971675F0C', N'Austria', N'AT', N'AUT', 43)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'B375FBC7-E0AF-4DDE-9E97-B08D64A5E607', N'Brunéi', N'BN', N'BRN', 673)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'B3938D17-1F88-4E46-B29F-F7BBCBAED891', N'España', N'ES', N'ESP', 34)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'B6912DF8-FA2D-40D6-AEE7-F6429D207343', N'Islas Heard y McDonald', N'HM', N'HMD', 0)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'B911D8BF-AE17-4876-A851-704F0FD7B23A', N'Antártida', N'AQ', N'ATA', 672)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'B9A85AC4-4294-4014-9268-04AB609EC063', N'Filipinas', N'PH', N'PHL', 63)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'BB40ECBF-A199-480E-825E-34D412218588', N'Mauritania', N'MR', N'MRT', 222)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'BB8F189D-3429-4F92-8C98-C5E622CA893C', N'Islas Turcas y Caicos', N'TC', N'TCA', 1649)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'BB96EF52-576B-41F8-B642-BCB14F336B93', N'Kuwait', N'KW', N'KWT', 965)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'BBBF772A-45A8-486B-8BF9-CD1F28AEC33E', N'Portugal', N'PT', N'PRT', 351)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'BD24EBAC-F705-471B-BF9A-D750BD67117A', N'Islas Cocos (Keeling)', N'CC', N'CCK', 61)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'BE7A4B72-9452-4913-8B78-55C06F280DA3', N'Puerto Rico', N'PR', N'PRI', 1)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'BF87E813-4E0E-4E7B-A668-F64FB67B617D', N'Azerbaiyán', N'AZ', N'AZE', 994)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'C1CD5691-BE96-4DC4-9143-8E4CA2400017', N'Malawi', N'MW', N'MWI', 265)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'C2BEDFFC-CC24-46D5-950D-EA933CFC6276', N'Groenlandia', N'GL', N'GRL', 299)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'C4549DE5-D00F-4FA0-BB09-45067E7FF0A9', N'Hong kong', N'HK', N'HKG', 852)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'C61844FD-81C7-4B36-A258-3C706612A7FD', N'Tanzania', N'TZ', N'TZA', 255)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'C7A63F63-5622-42B1-A134-03356517E64F', N'Islas Vírgenes Británicas', N'VG', N'VGB', 1284)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'C863E8CC-B6DA-461A-B392-8B5EB900A956', N'Yemen', N'YE', N'YEM', 967)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'C8E64217-62D6-4D79-9B50-0A96AB6279E5', N'Islandia', N'IS', N'ISL', 354)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'C9DB3ED7-EDBF-4668-819F-A9A3931C7642', N'Brasil', N'BR', N'BRA', 55)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'CA68E8BE-5D60-4F17-B9EE-934DC1C809F7', N'Eslovenia', N'SI', N'SVN', 386)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'CA6B14F2-A060-44D4-A7D6-7C92F9C84299', N'Anguila', N'AI', N'AIA', 1264)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'CA83C8CA-6F4E-4C54-BBE2-0DFA9060B63B', N'Luxemburgo', N'LU', N'LUX', 352)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'CAB3956B-3870-4F02-8866-C3058D2FD4FE', N'Jamaica', N'JM', N'JAM', 1876)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'CB2B9127-FED8-48F3-A671-67138596686F', N'Liberia', N'LR', N'LBR', 231)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'CB611039-9DA1-4207-B816-B00850C18DE4', N'Siria', N'SY', N'SYR', 963)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'CD935B6A-4AE6-45B4-B67B-ABCDED330B8D', N'Dinamarca', N'DK', N'DNK', 45)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'CE53D74F-53D6-42E2-B814-6EF1BE59AF14', N'Bhután', N'BT', N'BTN', 975)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'CE8825AF-278B-4E26-9E76-006DBB8EFA21', N'Cabo Verde', N'CV', N'CPV', 238)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'CEC92022-C3DA-4E69-93D0-0D4D84ABFB7A', N'Bielorrusia', N'BY', N'BLR', 375)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'CED9C4A9-34CE-496B-ACC8-1C528BD5AC2C', N'Islas Pitcairn', N'PN', N'PCN', 870)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'CF75CED2-A294-4A6E-9A73-1B76F556889B', N'Polinesia Francesa', N'PF', N'PYF', 689)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'D03DFABB-0C1E-4BC1-8112-A55058BE7369', N'República Dominicana', N'DO', N'DOM', 1809)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'D180C9E3-AD41-472E-91DE-5FC7007FBE26', N'México', N'MX', N'MEX', 52)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'D1EFADBE-C4F5-4470-8E49-66F11113A1B4', N'Islas Feroe', N'FO', N'FRO', 298)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'D3EA2244-7BDD-4728-825C-2F26B6FD554E', N'Suecia', N'SE', N'SWE', 46)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'D47150BF-21A5-4514-91FB-CEB98E3A5E35', N'Islas Cook', N'CK', N'COK', 682)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'D5F13F71-2280-49E2-932D-9CBDB347725D', N'Sudáfrica', N'ZA', N'ZAF', 27)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'D782BDF3-54F1-471A-8F19-2DA2B442213C', N'Antigua y Barbuda', N'AG', N'ATG', 1268)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'D7A9B1D7-CB9D-4874-A29E-733F5376729C', N'Angola', N'AO', N'AGO', 244)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'D96CA427-3E7C-4E3B-B005-E69E8EF9EF9D', N'Zambia', N'ZM', N'ZMB', 260)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'DA2A0BBC-8CE9-4560-9BAB-0374B6AD5AA0', N'Panamá', N'PA', N'PAN', 507)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'DADBC286-5599-4FCB-B9CF-43712A61A2A0', N'Estonia', N'EE', N'EST', 372)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'DB2D748D-C12B-49BC-9135-23B2724D3905', N'Uruguay', N'UY', N'URY', 598)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'DB34D2C0-83D1-4475-BA2B-C1CD21C86A08', N'Moldavia', N'MD', N'MDA', 373)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'DB617F6E-E12B-4A2E-8DD3-5A2CDEC37BD0', N'Gibraltar', N'GI', N'GIB', 350)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'DC45E1C4-D530-4892-9383-87E602463603', N'Guatemala', N'GT', N'GTM', 502)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'DD667B35-E1E0-4172-853C-DFA7ADE3AA6A', N'Montenegro', N'ME', N'MNE', 382)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'DDA6B1AB-E883-4AF3-8D89-0839862B5F1F', N'San Marino', N'SM', N'SMR', 378)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'DDC72007-E6B5-47DA-98C9-DEC42D63A5ED', N'Argelia', N'DZ', N'DZA', 213)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'DEFE8E80-AEE3-431C-8116-DF6B60D58E1B', N'Zimbabue', N'ZW', N'ZWE', 263)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'E0201281-07C8-48F0-A0D6-39A282C7CE90', N'Tonga', N'TO', N'TON', 676)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'E0BC0F93-861D-4ABB-BC59-7249FCB74F38', N'Japón', N'JP', N'JPN', 81)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'E18B1ACF-7532-42E0-9A8A-36E44DA8B16B', N'Honduras', N'HN', N'HND', 504)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'E72E3125-F3DC-4F7A-B7E0-ADD4FE0CD511', N'Botsuana', N'BW', N'BWA', 267)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'E89AF50E-57A2-480C-A80F-127671457C48', N'República de Sudán del Sur', N'SS', N'SSD', 211)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'E89E7CA3-A0C6-4680-A963-E56A2AB43B28', N'Estados Unidos de América', N'US', N'USA', 1)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'EA15C761-68F0-48F0-A837-E4BB5D79B1E9', N'Malasia', N'MY', N'MYS', 60)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'ED738CDC-6838-4A01-9FDD-6E436BC83EF7', N'Burkina Faso', N'BF', N'BFA', 226)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'EDF69AF8-26F3-4984-9E3B-D43C1FE71A55', N'Finlandia', N'FI', N'FIN', 358)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'EE33959E-2A17-4FA3-8CB3-CCD2DF7FC24B', N'Madagascar', N'MG', N'MDG', 261)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'EFF4D640-05B3-4C3B-AC6A-0BC2E4B65535', N'Uganda', N'UG', N'UGA', 256)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'F1CF0335-76A3-41A0-ABBC-6457A9A89D62', N'Mauricio', N'MU', N'MUS', 230)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'F1E6692F-F5D6-47BA-B5EE-8113382FB2C1', N'Eslovaquia', N'SK', N'SVK', 421)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'F202A02D-96E5-4B43-8746-1CD21AAC5687', N'Corea del Norte', N'KP', N'PRK', 850)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'F566C259-8D44-469B-B023-9FB4AEDD050C', N'Gambia', N'GM', N'GMB', 220)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'F57B66D0-FEAF-48F7-8703-246ED21BDE0C', N'Kazajistán', N'KZ', N'KAZ', 7)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'F61566BE-E5F2-40BB-B476-416CDCCB7967', N'Malta', N'MT', N'MLT', 356)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'F66BC47D-DAA8-44EF-B798-F5787CD88A1E', N'San Vicente y las Granadinas', N'VC', N'VCT', 1784)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'F8154FBB-B437-409A-944E-CF164F9AD2F7', N'Albania', N'AL', N'ALB', 355)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'F853F033-6BA6-4268-AB69-4F2742CDB1E4', N'Santo Tomé y Príncipe', N'ST', N'STP', 239)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'FA6D9D96-666F-4A89-88F8-FC839056FB33', N'Guinea', N'GN', N'GIN', 224)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'FD3A5D0F-C42B-4367-A07D-F101EB1460BD', N'Polonia', N'PL', N'POL', 48)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'FDDFC69E-C7EF-4ED0-992E-AD2CB586AFF7', N'Sudán', N'SD', N'SDN', 249)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'FF135782-D2FB-4381-BC71-26EEA45A3B1A', N'Camboya', N'KH', N'KHM', 855)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'FF23CDFC-F184-4F4F-9A4C-D864822CF148', N'Ucrania', N'UA', N'UKR', 380)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'FF81B770-9CC5-41CE-A258-7558C52C6600', N'Palau', N'PW', N'PLW', 680)
GO
INSERT [dbo].[paises] ([id], [nombre], [iso2], [iso3], [phoneCode]) VALUES (N'FFB6C4CC-A5AE-4384-8ED0-7C4B6306B1E1', N'India', N'IN', N'IND', 91)
GO
INSERT [dbo].[provincias] ([id], [nombre], [paisID]) VALUES (N'05A3772F-3696-41E1-A602-2A6138599D3B', N'Los Ángeles', N'E89E7CA3-A0C6-4680-A963-E56A2AB43B28')
GO
INSERT [dbo].[provincias] ([id], [nombre], [paisID]) VALUES (N'66F6A606-F08A-4F84-AF71-4B1DA3571CC4', N'Illinois', N'E89E7CA3-A0C6-4680-A963-E56A2AB43B28')
GO
INSERT [dbo].[provincias] ([id], [nombre], [paisID]) VALUES (N'E61F5493-E294-4753-82E1-8446F0B4410E', N'Nueva York', N'E89E7CA3-A0C6-4680-A963-E56A2AB43B28')
GO
INSERT [dbo].[vehiculo_servicio] ([id], [descripcion], [codigo]) VALUES (N'637BAB46-3A52-4ADB-B08E-6ECEEA0531E7', N'publico', N'2')
GO
INSERT [dbo].[vehiculo_servicio] ([id], [descripcion], [codigo]) VALUES (N'6DED4238-4A47-455A-8F35-E2598A790C29', N'diplomatico', N'3')
GO
INSERT [dbo].[vehiculo_servicio] ([id], [descripcion], [codigo]) VALUES (N'B31B2330-F23F-489A-AD8D-CE53E12D285F', N'oficial', N'4')
GO
INSERT [dbo].[vehiculo_servicio] ([id], [descripcion], [codigo]) VALUES (N'FBC73413-2C5E-4877-9871-5085F32E6B54', N'particular', N'1')
GO
INSERT [dbo].[vehiculo_tipo] ([id], [descripcion], [codigo]) VALUES (N'181DADFC-EAC1-4E57-A934-35F7179F3CAE', N'CAMPERO', N'6')
GO
INSERT [dbo].[vehiculo_tipo] ([id], [descripcion], [codigo]) VALUES (N'2C04DAD0-7D61-4CAF-83AC-53DD2EB049C6', N'BUS', N'2')
GO
INSERT [dbo].[vehiculo_tipo] ([id], [descripcion], [codigo]) VALUES (N'362CF415-99D8-41B5-9C54-4E15D34BCE8D', N'AUTOMOVIL', N'1')
GO
INSERT [dbo].[vehiculo_tipo] ([id], [descripcion], [codigo]) VALUES (N'534B1A01-9E6F-479D-A5FE-6B7041311F24', N'MOTOCICLETA', N'10')
GO
INSERT [dbo].[vehiculo_tipo] ([id], [descripcion], [codigo]) VALUES (N'5483EA8F-F9AF-40D6-8F0D-87B5C38DB44B', N'CUATRIMOTO', N'19')
GO
INSERT [dbo].[vehiculo_tipo] ([id], [descripcion], [codigo]) VALUES (N'807D3790-9989-4702-84C7-C5159EF0FD4A', N'MOTOCARRO', N'14')
GO
INSERT [dbo].[vehiculo_tipo] ([id], [descripcion], [codigo]) VALUES (N'84D32DB6-074F-4B5A-98AB-C6AE91B93FA0', N'MOTOTRICILO', N'17')
GO
INSERT [dbo].[vehiculo_tipo] ([id], [descripcion], [codigo]) VALUES (N'8B8DAB54-2195-40BD-BC15-CE389A4C4A2B', N'VOLQUETA', N'42')
GO
INSERT [dbo].[vehiculo_tipo] ([id], [descripcion], [codigo]) VALUES (N'9FCC6488-324D-4373-9A1A-9945D0D4E1DB', N'CAMIONETA', N'5')
GO
INSERT [dbo].[vehiculo_tipo] ([id], [descripcion], [codigo]) VALUES (N'A6845881-7B88-4108-993B-C203378F769D', N'CAMION', N'4')
GO
INSERT [dbo].[vehiculo_tipo] ([id], [descripcion], [codigo]) VALUES (N'C984F489-638A-468A-AD04-082A30BFFCE2', N'TRACTOCAMION', N'8')
GO
INSERT [dbo].[vehiculo_tipo] ([id], [descripcion], [codigo]) VALUES (N'D0277071-66EF-4D1A-A47E-7AA086182180', N'MICROBUS', N'7')
GO
INSERT [dbo].[vehiculo_tipo] ([id], [descripcion], [codigo]) VALUES (N'D10D3269-4B1D-4F76-8804-E5778EFF80CA', N'BUSETA', N'3')
GO
INSERT [dbo].[vehiculos] ([id], [nombre], [referencia], [linea], [color], [tipoID], [combustibleID], [servicioID]) VALUES (N'12asd1fdf-as1df-42BA-BF07-4DA11asdfa11', N'chevrolet tahoe', N'x', N'z', N'negro', N'362CF415-99D8-41B5-9C54-4E15D34BCE8D', N'62583378-8E9C-4E79-96C8-4208F6ADBC84', N'FBC73413-2C5E-4877-9871-5085F32E6B54')
GO
INSERT [dbo].[vehiculos] ([id], [nombre], [referencia], [linea], [color], [tipoID], [combustibleID], [servicioID]) VALUES (N'1FA8683B-797A-46E0-8E8A-3A7729D75B66', N'Hyundai Tucson NX4', N'a', N'b', N'metal griss', N'362CF415-99D8-41B5-9C54-4E15D34BCE8D', N'62583378-8E9C-4E79-96C8-4208F6ADBC84', N'FBC73413-2C5E-4877-9871-5085F32E6B54')
GO
INSERT [dbo].[vehiculos] ([id], [nombre], [referencia], [linea], [color], [tipoID], [combustibleID], [servicioID]) VALUES (N'3C0CCF30-8C41-45B6-912D-B7B50E114863', N'audi A4', N'x', N'z', N'metal griss', N'362CF415-99D8-41B5-9C54-4E15D34BCE8D', N'62583378-8E9C-4E79-96C8-4208F6ADBC84', N'FBC73413-2C5E-4877-9871-5085F32E6B54')
GO
INSERT [dbo].[vehiculos] ([id], [nombre], [referencia], [linea], [color], [tipoID], [combustibleID], [servicioID]) VALUES (N'6E8B826A-141D-4CC3-90AB-C3734D22E17F', N'Volkswagen Teramont', N'x', N'z', N'metal griss', N'362CF415-99D8-41B5-9C54-4E15D34BCE8D', N'62583378-8E9C-4E79-96C8-4208F6ADBC84', N'FBC73413-2C5E-4877-9871-5085F32E6B54')
GO
ALTER TABLE [dbo].[ciudades] ADD  DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[clientes] ADD  DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[combustible] ADD  DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[paises] ADD  DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[provincias] ADD  DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[vehiculo_servicio] ADD  DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[vehiculo_tipo] ADD  DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[vehiculos] ADD  DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[ventas] ADD  DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[ciudades]  WITH CHECK ADD FOREIGN KEY([provinciaID])
REFERENCES [dbo].[provincias] ([id])
GO
ALTER TABLE [dbo].[clientes]  WITH CHECK ADD FOREIGN KEY([lugarNacimiento])
REFERENCES [dbo].[ciudades] ([id])
GO
ALTER TABLE [dbo].[provincias]  WITH CHECK ADD FOREIGN KEY([paisID])
REFERENCES [dbo].[paises] ([id])
GO
ALTER TABLE [dbo].[vehiculos]  WITH CHECK ADD FOREIGN KEY([combustibleID])
REFERENCES [dbo].[combustible] ([id])
GO
ALTER TABLE [dbo].[vehiculos]  WITH CHECK ADD FOREIGN KEY([servicioID])
REFERENCES [dbo].[vehiculo_servicio] ([id])
GO
ALTER TABLE [dbo].[vehiculos]  WITH CHECK ADD FOREIGN KEY([tipoID])
REFERENCES [dbo].[vehiculo_tipo] ([id])
GO
ALTER TABLE [dbo].[ventas]  WITH CHECK ADD FOREIGN KEY([clienteID])
REFERENCES [dbo].[clientes] ([id])
GO
ALTER TABLE [dbo].[ventas]  WITH CHECK ADD FOREIGN KEY([vehiculoID])
REFERENCES [dbo].[vehiculos] ([id])
GO
USE [master]
GO
ALTER DATABASE [resourcesDW] SET  READ_WRITE 
GO
