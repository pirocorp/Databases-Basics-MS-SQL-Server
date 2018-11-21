ALTER TABLE Users
ADD CONSTRAINT atLeastFiveSymbols_Password
CHECK(LEN([Password]) >= 5)