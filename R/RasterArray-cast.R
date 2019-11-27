
#' S3-type method for RasterArray allowing View(), head() and tail() to work.
#' Convert RasterArray class objects to data.frames
#' 
#' Formal conversion method transforming the proxy object to a data.frame.
#' @param x a \code{RasterArray} class object.
#' @param row.names Argument to define the rownames of the resulting \code{data.frame}.
#' @param optional \code{logical} Flag to reset the rownames and colnaems attributes.
#' @param ... additional arguments passed to and from methods.
#' @examples
#' data(demo)
#' df <- as.data.frame(demo)
#' 
#' @method as.data.frame RasterArray
#' @export 
as.data.frame.RasterArray <- function(x, row.names=NULL, optional=FALSE,...){
	df <- as.data.frame(proxy(x))
	if(ncol(df)==1) colnames(df) <- "X0"
	if(!is.null(row.names)){
		rownames(df)<- row.names
	}
	if(optional){
		rownames(df) <- NULL
		colnames(df) <- NULL
	}
	return(df)
}



#' Convert Raster* objects to RasterArrays
#' 
#' The function converts \code{RasterLayer}, \code{RasterStack} and \code{RasterBrick} objects to \code{RasterArray} class objects.
#' @param from Object to be converted. 
#' 
#' @examples
#' data(demo)
#' recent <- demo[1]
#' # convert RasterLayer to RasterArray
#' ra <- as.RasterArray(recent)
#' @rdname asRasterArray
#' @exportMethod as.RasterArray
setGeneric("as.RasterArray", function(from) standardGeneric("as.RasterArray"))


#' @rdname asRasterArray
setMethod(as.RasterArray, signature=c("RasterLayer"), definition=function(from){
	RasterArray(raster::stack(from), index=1)
})

#' @rdname asRasterArray
setMethod(as.RasterArray, signature=c("RasterStack"), definition=function(from){
	RasterArray(from, index=1:nlayers(from))
})

#' @rdname asRasterArray
setMethod(as.RasterArray, signature=c("RasterBrick"), definition=function(from){
	RasterArray(stack(from), index=1:nlayers(from))
})

#' Coerce RasterLayer, RasterStack and RasterBrick object to a RasterArray
#'
#' The function coerces RasterLayer, RasterStack and RasterBrick object to a RasterArray.
#' @param from Object to be coerced.
#' @name as
#' @rdname coercion
setAs(from="RasterLayer", to="RasterArray", function(from){
	as.RasterArray(from)
})

#' @rdname coercion
#' @name as
setAs(from="RasterStack", to="RasterArray", function(from){
	as.RasterArray(from)
})

#' @rdname coercion
#' @name as
setAs(from="RasterBrick", to="RasterArray", function(from){
	as.RasterArray(from)
})

#' Coerce a RasterArray class object to a list
#' 
#' The function will return the items of the RasterArray as a list (conserving the names of the elements in the stack).
#' @param x A \code{RasterArray} class object.
#' @param ... arguments passed to or from methods.
#' 
#' @exportMethod as.list
setMethod("as.list","RasterArray", function(x,...){
	as.list(x@stack)
})