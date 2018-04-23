best <- function(state,outcome) {
  
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
  
  ## Return hospital name in that state with lowest 30-day death rate
  ## First get data for specified outcome
  dataByState <- split(outcomes, outcomes$State)
  if (outcome == "heart attack") {
    name <- paste(state, 
                  "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack",
                  sep=".")
    data <- as.numeric(paste(as.data.frame(dataByState[state])[,name]))
  }
  if (outcome == "heart failure") {
    name <- paste(state, 
                  "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure",
                  sep=".")
    data <- as.numeric(paste(as.data.frame(dataByState[state])[,name]))
  }
  if (outcome == "pneumonia") {
    name <- paste(state, 
                  "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia",
                  sep=".")
    data <- as.numeric(paste(as.data.frame(dataByState[state])[,name]))
  }

  colName <- paste(state, "Hospital.Name", sep=".")

  as.character(as.data.frame(dataByState[state])[which.min(data), colName]) 
  ## Return name of hospital for min death rate
}