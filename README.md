## Scale Up

Scale up is a project that takes an existing Rails project and optimizes it for performance on a significantly larger scale than the original scope accounted for.

Through refactoring and optimization the original source code that was designed around a few hundred records in the database is now able to handle 2.8 million records, including over 500,000 items. Average server response times are under 100ms and throughput over 600rpm when running a Capybara load script. Below is a screenshot of New Relic data from a 2 hour run of the load script leading up to the project evaluation.

The original source code can be found [here](https://github.com/turingschool-examples/keevah)

The project specifications can be found [here](https://github.com/turingschool/curriculum/blob/master/source/projects/the_scale_up.markdown)

[Find It Here on Heroku](http://scale-it-up.herokuapp.com)

<img src="http://joshcass.com/wp-content/uploads/2015/09/ScaleUp.gif" />
