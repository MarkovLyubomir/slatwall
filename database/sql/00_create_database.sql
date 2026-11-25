/* =============================================================================
   SlatwallCommerce - database create
   Slatwall Building Supply Co. commerce / omnichannel sidecar to Epicor BisTrack
   FICTIONAL SAMPLE - created to demonstrate the 3Pillar Helix Atlas platform.
   Original: Epicor PS migration, 2014-03-04. Settings last touched 2021-09-20 (PN)
   ============================================================================= */
IF DB_ID('SlatwallCommerce') IS NULL
    CREATE DATABASE SlatwallCommerce
GO
ALTER DATABASE SlatwallCommerce SET RECOVERY SIMPLE          -- "log kept filling up during the nightly batch" (2016)
GO
ALTER DATABASE SlatwallCommerce SET AUTO_SHRINK ON            -- 2014 default nobody changed
GO
ALTER DATABASE SlatwallCommerce SET COMPATIBILITY_LEVEL = 130 -- was 110 (SQL 2012) until 2021-09-20: raised for OPENJSON (ticket 3901); CLR bridge had to be re-signed
GO
ALTER DATABASE SlatwallCommerce SET READ_COMMITTED_SNAPSHOT OFF
GO
USE SlatwallCommerce
GO
