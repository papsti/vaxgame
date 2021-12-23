library(tidyverse)
library(lamW)
library(bazar)
library(latex2exp)

phi <- function(p, R0){
  1-p+1/R0*lambertW0(-(1-p)*R0*exp(-(1-p)*R0))
}

pcrit <- function(R0, s){1/s*(1-1/R0)}

scrit <- function(R0){1-1/(2*R0-1)}

f <- function(p, R0, r, s){
  (1-r)*s*p+(1-phi(s*p,R0)/(1-s*p))*(1-r)*(1-s)*p+(phi(s*p,R0)/(1-s*p))*(1-p)
}

iterate_f <- function(R0, r, s, p0, N){
  ## N = min number of steps
  i <- 1
  p <- numeric(N)
  p[1] <- p0
  
  # iterate map for N steps
  while (i < N){
    p[i+1] <- f(p[i], R0, r, s) # compute next p val
    i <- i + 1
  }
  
  attr(p, "params") <- c(N = N)
  return(p)
}

iterate_f_conv <- function(R0, r, s, p0, N = 1000, tol = 1e-8, n_recursion = 0, max_recursion = 2000){
  p <- iterate_f(R0, r, s, p0, N)
  
  ## check convergence
  if(length(almost.unique(p, tolerance = tol)) < N){
    ## if converged, return p
    return(p)
    } else {
    ## otherwise, increment recursion counter,
    ## and iterate if we haven't reached the max numer of recursions
    if(n_recursion == max_recursion){
      return(p)
    } else {
      n_recursion <- n_recursion + 1
      iterate_f_conv(
        R0, r, s, p[N],
        N = N,
        n_recursion = n_recursion,
        max_recursion = max_recursion
        )
    }
  }
}

get_period <- function(R0, r, s, p0 = 0){
  p <- iterate_f_conv(R0, r, s, p0)
  params <- attr(p, "params")
  
  # iterate another 1000 times to ensure convergence
  for(i in 1:1000){
    p <- iterate_f(
      R0, r, s, p[params[["N"]]],
      params[["N"]]
    )
  }
  
  if(any(is.nan(p))) return(NA)
  
  pfinal <- almost.unique(p, tolerance = 1e-6)
  period <- length(pfinal)
  
  if(period == params[["N"]]){
    ## this means we hit max recursion without convergence to a period less than N
    ## return NA, which means period >= N
    return(NA)
  }
  
  return(period)
}

SOHI_check <- function(R0, s, p0){
  if(p0 > pcrit(R0, s)) return(1/3)
  if(s >= scrit(R0)){
    if(f(p0, R0, 0, s) < pcrit(R0, s)) return(1)
    return(2/3)
  }
  return(0)
}

time_in_HI <- function(R0, r, s,
                       p0 = 0, N = 10){
  ## N = min number of iterations
  
  # set up counter for number of timesteps in HI interval (first checking if we're starting in the HI interval)
  time_in_HI_counter <- ifelse(p0 > pcrit(R0,s), 1, 0) 
      
      # Preallocate memory and set initial condition
      # at **end** of array
      # (to be compatible with setup of while loop)
      p = numeric(N)
      p[N] = p0
      
      # Set convergence tolerance
      tol = 1e-6
      
      # Set up while loop to iterate until convergence
      isConverged <- FALSE
      
      while (!isConverged){
        # compute trajectory
        p <- iterate_f(R0, r, s, p[N], N)
        
        # count steps in herd immunity and add to counter
        time_in_HI_counter <- time_in_HI_counter + sum(p[-1]>=pcrit(R0,s))
        
        # exclude first time step in this trajectory to avoid double counting
        # (first entry in the trajectory array p will be the initial condition
        # given to iterate_f(). since, in case we don't converge, we restart
        # the iteration from the last p value, this value will appear again at the
        # beginning of the next trajectory array, so we have to make sure we don't
        # double count these restarting points.)
        # (we've already accounted for the original p0 before the while loop when
        # we initialized the counter variable)
        # update convergence check variable
        
        # check convergence (and update while loop condition)
        isConverged <- (abs(p[N-1]-p[N])<tol)
      }

   return(time_in_HI_counter)
}
