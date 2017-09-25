# 1. import data from txt file as a character vector

tournamentinfo <- readLines('/Users/emiliembolduc/Documents/CUNY Data 607/Project1/tournamentinfo.txt')

# My first attempt returned the error: Warning message: In readLines("/Users/emiliembolduc/Documents/CUNY Data 607/Project1/tournamentinfo.txt") 
# incomplete final line found on '/Users/emiliembolduc/Documents/CUNY Data 607/Project1/tournamentinfo.txt
# opened the file and placed cursor at the end of the last line and hit return.

head(tournamentinfo)
tail(tournamentinfo)

# 2. remove the dashes
nodashinfo <- str_replace_all(string = tournamentinfo, pattern = "^-+$", "")
head(nodashinfo)

# remove the empty vector rows
nodashinfo2 <- nodashinfo[sapply(nodashinfo, nchar) > 0]
head(nodashinfo2)

# Combine the 2 vector rows of data into 1 vector row
# 1. Extract each even and odd rows to create separate vector tables:
# first tried this, but got error message: Error in nodashinfo2[c(TRUE, FALSE), ] : incorrect number of dimensions
PlayerName <- nodashinfo2[ c(TRUE, FALSE), ]

# then tried this, which worked:
PlayerName <- nodashinfo2[seq(1, 130, 2)]
head(PlayerName)
PlayerUSCFID <- nodashinfo2[seq(2, 130, 2)]
head(PlayerUSCFID)
#source: https://stackoverflow.com/questions/24440258/selecting-multiple-odd-or-even-columns-rows-for-dataframe

# 2. Remove header rows (I initially started to work on the regular expressions without removing the header row but it made it difficult & messy)
PlayerName1 <- PlayerName[-c(1:1)]
head(PlayerName1)
PlayerUSCFID1 <- PlayerUSCFID[-c(1:1)]
head(PlayerUSCFID1)

# 3. Combine the two vectors into one vector row per player
Combined <- mapply(paste, sep = "", PlayerName1, PlayerUSCFID1)
# TESTED and couldn't tell different between above: Combined2 <- mapply(paste, PlayerName, PlayerUSCFID, collapse = "")
head(Combined)
Combined
#sources: https://stackoverflow.com/questions/37901142/paste-multiple-rows-together-in-r

## Regular Expressions 1st attempt (1)
ID <- str_extract(string = Combined, pattern = "[0-9]{8}")
ID

PlayerID <- str_extract(string = Combined, pattern = "[\\s{3}]\\d{1,2}[\\s\\|]")
PlayerID <- str_trim(PlayerID)
PlayerID

First_Last <- str_extract(string = Combined, pattern = "\\s([[:alpha:] ]{5,})\\b\\s")
First_Last <- str_trim(First_Last)
First_Last

# Trying to extract the State. This did not work right: 
# > str_extract(string = Combined, pattern = "[[:alpha:]]{2}")

# Second attempt, I pulled the states from the old PlayerUSCFID vector:
State <- str_extract(string = PlayerUSCFID1, pattern = "[[:alpha:]]{2}")
State

NumPoints <- str_extract(string = Combined, pattern = "[0-9]\\.[0-9]")
NumPoints

# trying to do this with the selected symbols with special meanings (i.e. short-cuts)
PreRating <- str_extract(string = Combined, pattern = "\\s\\d{3,4}[^\\d]")
PreRating
# had to remove all the "P's" at the end of the ratings...
PreRating <- as.integer(str_extract(PreRating, "\\d+"))
PreRating

# Figuring out the Average Pre Chess Rating of Opponents
Opponents <- str_extract_all(string = Combined, pattern = "\\d{1,2}\\|")
# remove the "|" from the end
Opponents <- str_extract_all(string = Opponents, pattern = "\\d{1,2}")
Opponents

# Create a data frame with the relevant info thus far
ChessResults <- data.frame(First_Last, State, NumPoints, PreRating)
head(ChessResults, 5)
# Change the row names
colnames(ChessResults) <- c("Player's Name", "Player's State", "Total Number of Points", "Player's Pre-Rating")
head(ChessResults, 5)

# Write CSV in R
write.csv(ChessResults, file = "ChessResults.csv")
