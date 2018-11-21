ALTER TABLE Users
ADD CONSTRAINT AtLeastFiveSymbols
CHECK(LEN([Password]) >= 5)