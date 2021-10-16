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
/****** Object:  Table [dbo].[ventas]    Script Date: 10/16/2021 12:55:26 PM ******/
DROP TABLE IF EXISTS [dbo].[ventas]
GO
/****** Object:  Table [dbo].[vehiculos]    Script Date: 10/16/2021 12:55:26 PM ******/
DROP TABLE IF EXISTS [dbo].[vehiculos]
GO
/****** Object:  Table [dbo].[vehiculo_tipo]    Script Date: 10/16/2021 12:55:26 PM ******/
DROP TABLE IF EXISTS [dbo].[vehiculo_tipo]
GO
/****** Object:  Table [dbo].[vehiculo_servicio]    Script Date: 10/16/2021 12:55:26 PM ******/
DROP TABLE IF EXISTS [dbo].[vehiculo_servicio]
GO
/****** Object:  Table [dbo].[provincias]    Script Date: 10/16/2021 12:55:26 PM ******/
DROP TABLE IF EXISTS [dbo].[provincias]
GO
/****** Object:  Table [dbo].[paises]    Script Date: 10/16/2021 12:55:26 PM ******/
DROP TABLE IF EXISTS [dbo].[paises]
GO
/****** Object:  Table [dbo].[combustible]    Script Date: 10/16/2021 12:55:26 PM ******/
DROP TABLE IF EXISTS [dbo].[combustible]
GO
/****** Object:  Table [dbo].[clientes]    Script Date: 10/16/2021 12:55:26 PM ******/
DROP TABLE IF EXISTS [dbo].[clientes]
GO
/****** Object:  Table [dbo].[ciudades]    Script Date: 10/16/2021 12:55:26 PM ******/
DROP TABLE IF EXISTS [dbo].[ciudades]
GO
USE [master]
GO
/****** Object:  Database [resourcesDW]    Script Date: 10/16/2021 12:55:26 PM ******/
DROP DATABASE IF EXISTS [resourcesDW]
GO
/****** Object:  Database [resourcesDW]    Script Date: 10/16/2021 12:55:26 PM ******/
CREATE DATABASE [resourcesDW]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'resourcesDW', FILENAME = N'D:\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\resourcesDW.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'resourcesDW_log', FILENAME = N'D:\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\resourcesDW_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
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
/****** Object:  Table [dbo].[ciudades]    Script Date: 10/16/2021 12:55:26 PM ******/
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
/****** Object:  Table [dbo].[clientes]    Script Date: 10/16/2021 12:55:26 PM ******/
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
/****** Object:  Table [dbo].[combustible]    Script Date: 10/16/2021 12:55:26 PM ******/
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
/****** Object:  Table [dbo].[paises]    Script Date: 10/16/2021 12:55:26 PM ******/
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
/****** Object:  Table [dbo].[provincias]    Script Date: 10/16/2021 12:55:26 PM ******/
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
/****** Object:  Table [dbo].[vehiculo_servicio]    Script Date: 10/16/2021 12:55:26 PM ******/
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
/****** Object:  Table [dbo].[vehiculo_tipo]    Script Date: 10/16/2021 12:55:26 PM ******/
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
/****** Object:  Table [dbo].[vehiculos]    Script Date: 10/16/2021 12:55:26 PM ******/
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
/****** Object:  Table [dbo].[ventas]    Script Date: 10/16/2021 12:55:26 PM ******/
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
