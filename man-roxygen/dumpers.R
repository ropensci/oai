\dontrun{

### Dumping raw XML to text files

# This will write a set of XML files to a temporary directory
fnames <- list_identifiers(from="2018-06-01T",
                           until="2018-06-14T",
                           as="raw",
                           dumper=dump_raw_to_txt,
                           dumper_args=list(file_dir=tempdir()))
# vector of file names created
str(fnames)
all( file.exists(fnames) )
# clean-up
unlink(fnames)


### Dumping raw XML to a database

# Connect to in-memory SQLite database
con <- DBI::dbConnect(RSQLite::SQLite(), dbname=":memory:")
# Harvest and dump the results into field "bar" of table "foo"
list_identifiers(from="2018-06-01T",
                 until="2018-06-14T",
                 as="raw",
                 dumper=dump_raw_to_db,
                 dumper_args=list(dbcon=con,
                                  table_name="foo",
                                  field_name="bar") )
# Count records, should be 101
DBI::dbGetQuery(con, "SELECT count(*) as no_records FROM foo")

DBI::dbDisconnect(con)




}
