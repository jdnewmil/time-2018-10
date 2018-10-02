# time-2018-10

Overview of Date-Time Handling in R

These materials were prepared for a meeting of the East Bay R Beginners Meetup Group in Oakland on 2-Oct-2018.

### To build the main presentation using RStudio:

- Open the "time-2018-10.Rproj" project file with RStudio
- Use the Console pane to type in the command
```
setwd( "presentation" )
```
(or other appropriate directory)
- Then use the "Files" pane to click on the "presentation" directory,
- then click on the "DateTimeHowto.Rmd" file in the "Files" pane to open it,
- Then click the "knit" button at the top of the Editor pane with the "DateTimeHowto.Rmd".

### To build the main presentation using only the R console:

- Start R
- Set the working directory to the "presentation" directory. Your R program may have a menu item for this, or you can use the setwd() function.
- Run the command:
    ```
    rmarkdown::render( "DateTimeHowto.Rmd" )
    ```
    + Optionally you may need to install the `rmarkdown` package from CRAN if you have not already done so:
    ```
    install.packages( "rmarkdown" )
    ```

### Too much work?

You can open the Rmarkdown files and read them directly... they are plain text files.
