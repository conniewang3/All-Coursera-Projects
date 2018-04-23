rankhospital <- function(state, outcome, num = 1) {
  ## Read outcome data
  outcomes <- read.csv("outcome-of-care-measures.csv")
  
  
  ## Check that state and outcome are valid
  if (!(state %in% levels(outcomes$State))) {
    print("Please enter a valid two letter state abbreviation")
    return()
  }
  if (!(outcome %in% c("heart attack", "heart failure", "pneumonia"))) {
    print("Please enter a valid outcome")
    return()    
  }
  
  
  ## Return hospital name in that state with the given rank 30 day death rate
  ## First get data for specified outcome in specified state
  dataByState <- split(outcomes, outcomes$State)
  name <- paste(state, "Hospital.Name", sep=".")
  if (outcome == "heart attack") {
    deathRate <- paste(state, 
                  "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack",
                  sep=".")

    data <- as.data.frame(dataByState[state])[,c(name, deathRate)]
  }
  if (outcome == "heart failure") {
    deathRate <- paste(state, 
                  "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure",
                  sep=".")
    data <- as.data.frame(dataByState[state])[,c(name, deathRate)]
  }
  if (outcome == "pneumonia") {
    deathRate <- paste(state, 
                  "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia",
                  sep=".")
    data <- as.data.frame(dataByState[state])[,c(name, deathRate)]
  }
  ## Then convert data to a named vector
  dataVector <- as.numeric(paste(data[,deathRate]))
  names(dataVector) <- as.character(data[,name])
  cleanData <- dataVector[complete.cases(dataVector)]    ## Clean data
  sortedData <- sort(cleanData)    ## Sort cleanData lowest to highest
  print(sortedData)
  names(sortedData)[num]
}