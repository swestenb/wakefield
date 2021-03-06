% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/r_series.R
\name{r_series}
\alias{r_series}
\title{Data Frame Series (Repeated Measures)}
\usage{
r_series(fun, j, n, ..., integer = FALSE, relate = NULL, rep.sep = "_")
}
\arguments{
\item{fun}{A \pkg{wakefield} variable function.}

\item{j}{The number of columns to produce.}

\item{n}{The number of rows to produce.}

\item{integer}{logical.  If \code{TRUE} factor columns will be coerced to
integer.}

\item{relate}{Allows the user to specify the relationship between columns.
May be a named list of \code{c("operation", "mean", "sd")} or a string of
the form of "fM_sd" where `f` is one of (+, -, *, /), `M` is a mean value, and
`sd` is a standard deviation of the mean value (e.g., \code{"*4_1"}).  See
\code{\link[wakefield]{relate}} for details.}

\item{rep.sep}{A separator to use for repeated variable names.  For example
if the \code{\link[wakefield]{age}} is used three times
(\code{r_data_frame(age, age, age)}), the name "Age" will be assigned to all
three columns.  The results in column names \code{c("Age_1", "Age_2", "Age_3")}.}

\item{\ldots}{Additional arguments passed to \code{fun}.}
}
\value{
Returns a \code{\link[dplyr]{tbl_df}}.
}
\description{
Produce a \code{\link[dplyr]{tbl_df}} data frame of repeated measures from a
wakefield variable function.
}
\examples{
r_series(grade, 5, 10)

## Custom name prefix
r_series(likert, 5, 10, name = "Question")

## Convert factors to integers
r_series(likert_7, 5, 10, integer = TRUE)

## Related variables
r_series(likert, 10, 200, relate = list(operation = "*", mean = 2, sd = 1))
r_series(likert, 10, 200, relate = "--3_1")
r_series(age, 10, 200, relate = "+5_0")

## Change sd to reduce/increase correlation
round(cor(r_series(grade, 10, 10, relate = "+1_2")), 2)
round(cor(r_series(grade, 10, 10, relate = "+1_0")), 2)
round(cor(r_series(grade, 10, 10, relate = "+1_.5")), 2)
round(cor(r_series(grade, 10, 10, relate = "+1_20")), 2)

## Plot Example 1
library(dplyr); library(ggplot2)

dat <- r_data_frame(12,
    name,
    r_series(likert, 10, relate = "+1_.5")
)

# Suggested use of tidyr or reshape2 package here instead
dat <- data.frame(
    ID = rep(dat[[1]], ncol(dat[-1])),
    stack(dat[-1])
)

dat[["Time"]] <- factor(sub("Variable_", "", dat[["ind"]]), levels = 1:10)
ggplot(dat, aes(x = Time, y = values, color = ID, group = ID)) +
    geom_line(size=.8)

## Plot Example 2
dat <- r_data_frame(12,
    name,
    r_series(grade, 100, relate = "+1_2")
)

# Suggested use of tidyr or reshape2 package here instead
dat <- data.frame(
    ID = rep(dat[[1]], ncol(dat[-1])),
    ind = rep(colnames(dat[-1]), each = nrow(dat)),
    values = unlist(dat[-1])
)


dat[["Time"]] <- as.numeric(sub("Grade_", "", dat[["ind"]]))
ggplot(dat, aes(x = Time, y = values, color = ID, group = ID)) +
    geom_line(size=.8) + theme_bw()
}
\references{
\url{https://github.com/trinker/wakefield/issues/1/#issuecomment-96166910}
}
\seealso{
\code{\link[wakefield]{r_list}},
\code{\link[wakefield]{r_data_frame}}
\code{\link[wakefield]{r_dummy}}
}
