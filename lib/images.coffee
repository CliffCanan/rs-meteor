@BuildingImages = new FS.Collection "images",
  stores: [
    new FS.Store.FileSystem("images")
    new FS.Store.FileSystem "thumbs",
      transformWrite: (fileObj, readStream, writeStream) ->
        gm(readStream, fileObj.name()).resize("800", "500").stream().pipe(writeStream)
#        gm(readStream, fileObj.name()).resize("800", "500", ">").gravity('Center').extent("800", "500").stream().pipe(writeStream)
#        gm(readStream, fileObj.name()).resize("800", "500").gravity('Center').extent("800", "500").stream().pipe(writeStream)
  ]
  filter:
    allow:
      contentTypes: ['image/*'] # allow only images in this FS.Collection
