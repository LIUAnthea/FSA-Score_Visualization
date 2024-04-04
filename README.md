# FSA-Score_Visualization <br>
## Introduction
In this project, our goal is to visualize the outcomes of the British Columbia Foundation Skills Assessments in Numeracy, Reading, and Writing for Grades 4 and 7, spanning from the 2007/2008 to 2020/2021 academic years. This analysis is designed to offer insights into students' performance, trends, differences among sub-populations, and progress in these areas over the 13-year period. It focuses on comparisons between different districts and types of students and evaluates whether students meet or exceed expectations.
We employ Tableau and Power BI to develop a comprehensive dashboard and utilize a variety of visualization techniques, such as creating parameters, calculation fields, and DAX measures. These techniques enable us to analyze different metrics, providing deeper insights into the dataset.<br>

## About the dataset
The dataset for this analysis was sourced from the "The BC Data Catalogue - Province of British Columbia" online platform. By amalgamating two distinct datasets—one spanning the years 2007/2008 to 2016/2017 and the other from 2017/2018 to 2020/2021—we have compiled FSA scores covering 13 consecutive years.
This FSA dataset encompasses 15 columns and 26,310 rows, featuring variables such as SCHOOL_YEAR, DATA_LEVEL, PUBLIC_OR_INDEPENDENT, DISTRICT_NUMBER, DISTRICT_NAME, SUB_POPULATION, GRADE, FSA_SKILL_CODE, NUMBER_EXPECTED_WRITERS, NUMBER_WRITERS, NUMBER_UNKNOWN, NUMBER_EMERGING, NUMBER_ONTRACK, NUMBER_EXTENDING, and SCORE.
The "DATA_LEVEL" variable differentiates schools at the "Province Level" from those at the "District Level." The "SUB_POPULATION" variable segregates students into categories like "All Students," "Indigenous," "Non-Indigenous," "Without Diverse Abilities," and "With Diverse Abilities." The "NUMBER_UNKNOWN" variable accounts for students who were expected to participate but abstained from writing the test. The "SCORE" variable indicates the average score for the district or province, derived by aggregating individual scores and dividing by the total number of test participants. Score intervals range from 200 to 800 for Numeracy and Reading, and between 0 to 10 for Writing. Apart from the "GRADE" column, all other information in this dataset is encoded in character format.<br>

## Tableau Dashboard

<p>
    <img width="468" alt="image" src="https://github.com/LIUAnthea/FSA-Score_Visualization/assets/130535253/2b45df07-b06f-4c03-96c5-1dac18710a9d">
    <em>in Figure 1 </em>
</p>
As shown in Figure 1, the FSA Score dashboard comprises five plots: a frequency chart, an area chart, two bar charts, and a distribution chart. The frequency chart enables users to see the percentage of the total score where they are located. Based on the selected FSA Skill Code and score, the frequency chart and the percentage number displayed atop it dynamically shift. The area chart visualizes the years in which students achieve the highest or lowest scores; the two bar charts provide a detailed look at score distributions among different test subjects, districts, school types, and student performances. The distribution chart offers a comparison of students who are performing well, averagely, or falling behind across different sub-demographics.<br>
We have incorporated two dropdown menus for users to select the test subject they wish to view and a ranking parameter range from the top 5 to the top 25. Two sliders have also been introduced in this dashboard, allowing users to input the score range and year range they wish to examine in further detail.<br>

## Power BI Dashboard
<p>
    <img width="468" alt="image" src="https://github.com/LIUAnthea/FSA-Score_Visualization/assets/130535253/52e365a1-9e72-433b-b554-e0bba4c3366c">
    <em>in Figure 2 </em>
</p>
In Figure 2, the FSA Score Dashboard presents a diverse array of visualizations, including one gauges, three cards, three KPI, one bar charts, and a map to provide a multifaceted view of student performance across districts. The gauge displays the average score, offering a quick and dynamic measure against the maximum scale. The cards and KPIs, highlighting percentages and sums, give a snapshot of writers' performance relative to benchmarks. A comparison of average scores is effectively presented through a bar chart, which also juxtaposes the sum of writers according to districts. The map furthers geographical analysis by plotting the average score per district, enabling users to visually correlate performance with location. 
As seen in Figure 2, the dashboard contains several interactive elements, including dropdown menus and sliders for test subjects, ranking parameters, score, and year range. The charts change dynamically based on the filters applied, enabling users to interpret the data according to specific informational needs.



