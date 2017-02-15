# Seminar
*** if you want to test the app, you can log in using login: 'test', pswd: 'test' ***

*** use Seminars.bak to restore or SeminarsCreate.sql to create database ***

Seminar app has two sections: for clients and for admins.

<b><i>For clients</i></b>

Get the list of all available courses (excluding filled ones), their description and date. 

Search courses by title. 
When you choose one - select it, fill the form and apply.
<hr/>
<b><i>For admins</i></b>

Log in.
There are 3 tabs:
  - Applications
  - Courses
  - Teachers
  
<b>Applications</b>

Grid showing all the applications, with the number of approved applications next to the Course in question. 

Change application status on the fly (approve or reject). Delete unwanted applications.

Search applications by title, or filter them by status (all, unprocessed, approved, rejected).

Sort by any column.

<b>Courses</b>
  
Grid showing all the courses.

Enter new courses or update any of the info of existing ones.

Search by title. Sort by any column.

Delete course, but only if it doesn't have any applications.

Filled courses won't be displayed on landing page.

<b>Teachers</b>
  
Grid showing all the teachers (admin users).

Enter new teachers or update any of the info of existing ones.

Search by name.

Delete teacher, but only if they don't teach any course.

