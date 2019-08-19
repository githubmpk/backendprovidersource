USE [ResultsPortal]
GO

/****** Object:  Table [dbo].[userPreferences]    Script Date: 5/3/2019 1:04:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblUserPreferences](
       [iId] [int] IDENTITY(1,1) NOT NULL,
       [iUser_id] [varchar] (100) NULL,
       [vchTestProfile] [varchar] (30) NULL,
       [chUserLanguage] [char](1) NOT NULL,
       [iViewPeriod] [int] NOT NULL,
       [vchViewStatus] [varchar](15) NULL,
       [chReportLayout] [char](1) NOT NULL,
       [bCumulativeDirection] [bit] NOT NULL,
       [dtCreated] [datetime] NULL,
       [dtModified] [datetime] NULL,
CONSTRAINT [PK_tblUserPreferences] PRIMARY KEY CLUSTERED
(
       [iId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[tblUserPreferences] ADD  CONSTRAINT [DF_tblUserPreferences_chUserLanguage]  DEFAULT ('E') FOR [chUserLanguage]
GO

ALTER TABLE [dbo].[tblUserPreferences] ADD  CONSTRAINT [DF_tblUserPreferences_iViewPeriod]  DEFAULT ((3)) FOR [iViewPeriod]
GO

ALTER TABLE [dbo].[tblUserPreferences] ADD  CONSTRAINT [DF_tblUserPreferences_chReportLayout]  DEFAULT ('P') FOR [chReportLayout]
GO

ALTER TABLE [dbo].[tblUserPreferences] ADD  CONSTRAINT [DF_tblUserPreferences_bCumulativeDirection]  DEFAULT ((1)) FOR [bCumulativeDirection]
GO
