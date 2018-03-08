#PhDORG

PhDORG is a command-line tool that generates folders for experiments, literature reviews, thesis notes, talks/presentations and meetings, and tries to keep them all in one spot. For talks and meetings, it polls the Google Calendar API to check what's on today, and whether you'd like to create a group of folders for that item.

This is inspired from a conversation with Fernando Diaz and [Dan Kleiman's blog post](https://dankleiman.com/2018/01/28/keeping-an-engineering-notebook/).

##Install+Usage

Assumes you have python2 and ruby installed.

`bundle install`
`./gen.rb <experiment|review|thesis|calendar> [name]`

For `experiment`, a `data`, `notes`, `results`, `source` and `description.txt` will be formed in a directory with the supplied `name`. Additionally, `review` and `thesis` is called the same way, however, the `results` directory is omitted.
For the `calendar` option, a name is not required as the first word from each event shown in your Google Calendar is used to name the folder, along with the date/time of that event. E.g. `8_3_2018_2_30_test`.

##Caveats

It's currently hardcoded to search for the strings "Rodger" and classify meetings and talks based on my use-cases. 
