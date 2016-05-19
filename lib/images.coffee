# REFERENCE: http://aheckmann.github.io/gm/docs.html

@BuildingImages = new FS.Collection "images",
  stores: [
    new FS.Store.FileSystem("images")
    new FS.Store.FileSystem "thumbs",
      transformWrite: (fileObj, readStream, writeStream) ->
#        gm(readStream, fileObj.name()).gravity('Center').crop(720, 540, 0, 0).resize("800", null).stream().pipe(writeStream)
        gm(readStream, fileObj.name()).gravity('Center').resize("800", "600").stream().pipe(writeStream)

#       gm(readStream, fileObj.name()).resize("800", "500", ">").gravity('Center').extent("800", "500").stream().pipe(writeStream)
#       gm(readStream, fileObj.name()).resize("800", "500").gravity('Center').extent("800", "500").stream().pipe(writeStream)
    new FS.Store.FileSystem "thumbsSmall",
      transformWrite: (fileObj, readStream, writeStream) ->
        gm(readStream, fileObj.name()).gravity('Center').resize("400", "300").stream().pipe(writeStream)
#        gm(readStream, fileObj.name()).gravity('Center').crop(720, 540, 0, 0).resize("400", null).stream().pipe(writeStream)
  ]
  # filter:
  #   allow:
  #     contentTypes: ['image/*'] # allow only images in this FS.Collection
