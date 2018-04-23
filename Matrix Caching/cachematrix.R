## These two functions cache the inverse of a matrix

makeCacheMatrix <- function(x = matrix()) {
  ## Returns a matrix object that can cache its inverse
  ## Input: x is an input matrix that we want to cache the inverse of
  inv <- NULL      ## This is where we're storing the cached inverse
  
  set <- function(y) {      ## A function to set the cached matrix 
                            ## and clear the cached inverse matrix
    x <<- y
    inv <<- NULL
  }
  
  get <- function() x      ## A function to retrive the cached matrix
  setInverse <- function(inverse) inv <<- inverse      ## A function to set the 
                                                       ## cached inverse matrix
  getInverse <- function() inv      ## A function to retrieve the cached
                                    ## inverse matrix
  list(set = set, get = get, 
       setInverse = setInverse, 
       getInverse = getInverse)      ## Return a list of functions
}


cacheSolve <- function(x, ...) {
  ## Returns a matrix that is the inverse of 'x'
  ## Returns the cached inverse if there is one available
  
  inv <- x$getInverse()      ## Try to retrieve cached inverse matrix
  if(!is.null(inv)) {        
    ## If cached inverse exists, notify user that a cached value is being 
    ## returned, and then return the cached inverse
    message("getting cached data")
    return(inv)
  }
  
  ## If no cached inverse exists, calculate the inverse and set it as the 
  ## cached inverse
  data <- x$get()
  inv <- solve(data, ...)
  x$setInverse(inv)
  inv
}
