/* 1) This current dataset for this project contains records of first graduating class of a startup MBA program.
   2) It includes the details and scores from their application, the program itself and their status after 2 months.
   3) Each row consist of record about each students: Student ID, Undergrad Degree, Undergrad Grade, MBA Grade, Work Experience, Employability (Before), Employability (After), Status, Annual Salary.
*/
-----------------------------------------------------------------------------------

-- Q1) Getting all the records for further analysis

SELECT
*
FROM
project_1;
------------------------------------------------------------------------------------

-- Q2) Counting total number of rows for further analysis

select
count(*)
from
project_1;
-----------------------------------------------------------------------------------

-- Q3) Finding total different types of Undergraduate degrees present in this dataset

select
distinct(UndergradDegree) as `Degrees available`
from
project_1;
-----------------------------------------------------------------------------------

-- Q4) Students distribution basis of degrees applied too

select
distinct(UndergradDegree) as `Undergrad Degrees`,
count(distinct studentID) as `students enrolled`
from 
Project_1
group by 
UndergradDegree
union
select
"Total",
count(distinct studentID)
from 
Project_1;
-----------------------------------------------------------------------------------

-- Q5) Find Average, Maximum and Minimum  marks obtained in Undergrad Grade and MBA grade

select
"Undergrad Grade" as "Degree",
avg(UndergradGrade) as `Avg Marks`,
max(UndergradGrade) as `Maximum Marks`,
min(UndergradGrade) as `Minimum Marks`
from
Project_1
union
select
"MBA Grade",
avg(MBAGrade) as `Avg Marks`,
max(MBAGrade) as `Maximum Marks`,
min(MBAGrade) as `Minimum Marks`
FROM
Project_1;
-----------------------------------------------------------------------------------

-- Q6) which students have performed better in MBA after graduating

select
*
from
Project_1
where MBAGrade > UndergradGrade
order by MBAGrade desc;
-----------------------------------------------------------------------------------

-- Q7) which students have performed worse in MBA after graduating
 
select
*
from
Project_1
where MBAGrade < UndergradGrade
order by UndergradGrade asc;
-----------------------------------------------------------------------------------

-- Q8) count and % of total students who have  performed better in MBA after graduating and have performed worse in MBA after graduating


select
"Count" as "",
count(case when MBAGrade >= UndergradGrade then studentID end)  as "Overperforming Student",
count(case when MBAGrade < UndergradGrade then studentID end)  as "Underperforming Student",
Count(StudentID) as "Total Students"
from
Project_1
union
select
"% of Total",
concat(Round(((count(case when MBAGrade >= UndergradGrade then studentID end)/count(studentID))*100),2),"%")  as "Overperforming Student",
concat(Round(((count(case when MBAGrade < UndergradGrade then studentID end)/count(studentID))*100),2),"%")  as "Underperforming Student",
concat(Round((count(studentID)/count(studentID)*100),2),"%")  as "Total students"
from
Project_1;
-----------------------------------------------------------------------------------

/* Q9) count and % of total students who have  performed better in MBA after graduating and have performed worse in MBA after graduating
"among diff degrees" */

create temporary table Performances

select
UndergradDegree as degree,
"Count" ,
count(case when MBAGrade >= UndergradGrade then studentID end)  as "Overperforming Student",
count(case when MBAGrade < UndergradGrade then studentID end)  as "Underperforming Student",
Count(StudentID) as "Total Students"
from
Project_1
group by 
UndergradDegree
union
select
UndergradDegree,
"% of Total",
concat(Round(((count(case when MBAGrade >= UndergradGrade then studentID end)/count(studentID))*100),2),"%")  as "Overperforming Student",
concat(Round(((count(case when MBAGrade < UndergradGrade then studentID end)/count(studentID))*100),2),"%")  as "Underperforming Student",
concat(Round((count(studentID)/count(studentID)*100),2),"%")  as "Total students"
from
Project_1
group by 
UndergradDegree;

select
*
from 
performances
order by
"Total Students"
;
-----------------------------------------------------------------------------------

-- Q10) count and % of total students who have work experience and do not have  (overall and by degree) 

select
"Overall",
count(studentID) as "Total students" ,
count(case when WorkExperience = "Yes" then WorkExperience end) as "Having Work experience (count)",
count(case when WorkExperience = "No" then WorkExperience end) as "Having Work experience (count)",
concat(Round(((count(case when WorkExperience = "Yes" then WorkExperience end)/count(WorkExperience))*100),2),"%") as "Having Work experience (% share)",
concat(Round(((count(case when WorkExperience = "No" then WorkExperience end)/count(WorkExperience))*100),2),"%") as "Having Work experience (% share)"
from
Project_1

union

select
UndergradDegree,
count(studentID),
count(case when WorkExperience = "Yes" then WorkExperience end) as "Having Work experience",
count(case when WorkExperience = "No" then WorkExperience end) as "Having Work experience",
concat(Round(((count(case when WorkExperience = "Yes" then WorkExperience end)/count(WorkExperience))*100),2),"%") as "Having Work experience (% share)",
concat(Round(((count(case when WorkExperience = "No" then WorkExperience end)/count(WorkExperience))*100),2),"%") as "Having Work experience (% share)"
from
Project_1
group by
UndergradDegree;
-----------------------------------------------------------------------------------

-- Q11) count and % Total of business and finance Students who have score more than 80 in MBA, 75 in Undergraduate and have prior work experience

select
count(studentID) as "Total students",
concat(round((count(studentID)/1200),2),"%") as "% of Total students"
from
Project_1
where
UndergradDegree in ("Business","Finance") and UndergradGrade > 75 and MBAGrade > 80 and WorkExperience = "Yes"
;
-----------------------------------------------------------------------------------

/* Q12) a) How many students have increased or maintained their employability test in their second round and what is their avg % improvement in score
		b) How many students have decreased their employability test in their second round and what is their avg % deterioration in score
*/

select
"a" as "" ,
count(case when Employability_After >= Employability_Before then Employability_After end ) as "Total number of students",
concat(round(avg(case when Employability_After >= Employability_Before then Employability_before end),2)," marks") as "Employability before avg.score",
concat(round(avg(case when Employability_After >= Employability_Before then Employability_After end),2)," marks") as "Employability after avg.score",
concat(((((round(avg(case when Employability_After >= Employability_Before then Employability_after end),2)) - (round(avg(case when Employability_After >= Employability_Before then Employability_before end),2)))/(round(avg(case when Employability_After >= Employability_Before then Employability_After end),2)))*100),"%") as " Avg. % change in marks" 
from
project_1
union
select
"b" as "" ,
count(case when Employability_After < Employability_Before then Employability_After end ) as "Total number of students",
concat(round(avg(case when Employability_After < Employability_Before then Employability_before end),2)," marks") as "Employability before avg.score",
concat(round(avg(case when Employability_After < Employability_Before then Employability_After end),2)," marks") as "Employability after avg.score",
concat(((((round(avg(case when Employability_After < Employability_Before then Employability_after end),2)) - (round(avg(case when Employability_After < Employability_Before then Employability_before end),2)))/(round(avg(case when Employability_After < Employability_Before then Employability_After end),2)))*100),"%") as " % change in marks" 
from
project_1;
-----------------------------------------------------------------------------------

-- Q13) How many students got placed, not got placed and what's their avg. annual salary in dollars (filtered by degree)

select
status as "Status of students",
UndergradDegree as "Undergrad Degree",
count(studentID) as "Students",
concat(round(avg(annualSalary),1)," $") as "avg. annual salary (dollars)"
from 
Project_1
group by 
1,2
order by
1,4 desc;
-----------------------------------------------------------------------------------

-- Q14) Is their any difference in salary between who have prior work experience and who doesn't (who have been placed)

select
WorkExperience as "having Work Experience or not",
count(studentID) as "student distribution",
max(AnnualSalary) as "Maximum salary",
round(avg(AnnualSalary),1) as "average salary",
min(AnnualSalary) as "Minimum salary"
from
Project_1
where Status = "Placed" and AnnualSalary > 0 
group by 
WorkExperience;
-----------------------------------------------------------------------------------

-- Q15) Which degree to opt for based on placements,annual salary and chances of getting hight employability score on avg.

select
UndergradDegree as "Undergrad Degree",
max(AnnualSalary) as "Maximum salary",
round(avg(AnnualSalary),1) as "average salary",
min(AnnualSalary) as "Minimum salary",
concat(round((count(case when Status = "Placed"  then Status end)/(count(Status))*100),1),"%")as "Placement rate"
from
Project_1
group by 
UndergradDegree
order by
5 desc;
-----------------------------------------------------------------------------------