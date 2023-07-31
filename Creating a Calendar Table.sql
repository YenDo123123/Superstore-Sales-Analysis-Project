/* Create a calendar table */

CREATE TABLE calendar(
       [Date] Date NOT NULL,
       [Day] char(10) NOT NULL,
       [DayOfWeek] tinyint NOT NULL,
       [DayOfMonth] tinyint NOT NULL,
       [DayOfYear] smallint NOT NULL,
       [PreviousDay] date NOT NULL,
       [NextDay] date NOT NULL,
       [WeekOfYear] tinyint NOT NULL,
       [Month] char(10) NOT NULL,
       [MonthOfYear] tinyint NOT NULL,
       [QuarterOfYear] tinyint NOT NULL,
       [Year] int NOT NULL,
       [IsWeekend] bit NOT NULL,
    )
 
ALTER TABLE calendar
ADD CONSTRAINT PK_CalendarDate PRIMARY KEY (Date); 

-- Populate the calendar table with data
DECLARE @StartDate DATE
DECLARE @EndDate DATE
SET @StartDate = '2017-01-01' 
SET @EndDate = DATEADD(d, 365*3, @StartDate)
WHILE @StartDate <= @EndDate
      BEGIN
             INSERT INTO calendar values
             (
                   @StartDate,
                              CONVERT(CHAR(10), DATENAME(WEEKDAY, @StartDate)),
                              CONVERT(Tinyint,DATEPART(WEEKDAY, @StartDate)),
                              CONVERT(Tinyint,DATEPART(DAY, @StartDate)),
                              CONVERT(smallint, DATEPART(DAYOFYEAR, @StartDate)),
                              DATEADD(day, -1, CONVERT(DATE, @StartDate)),
                              DATEADD(day, 1, CONVERT(DATE, @StartDate)),
                              CONVERT(tinyint, DATEPART(WEEK,@StartDate)),
                              CONVERT(CHAR(10), DATENAME(MONTH, @StartDate)),
                              CONVERT(TINYINT, DATEPART(MONTH, @StartDate)),
                              CONVERT(TINYINT, DATEPART(QUARTER,@StartDate)),
                              CONVERT(INT, DATEPART(YEAR,@StartDate)),
                              CASE 
                                   WHEN CONVERT(Tinyint,DATEPART(WEEKDAY, @StartDate)) in (1,7)
                                   THEN 1
                                   ELSE 0 
                                 END
             )
             
             SET @StartDate = DATEADD(dd, 1, @StartDate)
      END