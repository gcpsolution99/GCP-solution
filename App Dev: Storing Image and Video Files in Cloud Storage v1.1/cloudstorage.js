// Copyright 2017, Google, Inc.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
'use strict';

const config = require('../config');

const Storage = require('@google-cloud/storage');


const storage = Storage({
 projectId: config.get('GCLOUD_PROJECT')
});


const GCLOUD_BUCKET = config.get('GCLOUD_BUCKET');

const bucket = storage.bucket(GCLOUD_BUCKET);

function sendUploadToGCS (req, res, next) {
  
    if (!req.file) {
      return next();
    }

    const oname = Date.now() + req.file.originalname;
  
    const file = bucket.file(oname);
  
    const stream = file.createWriteStream({
      metadata: {
        contentType: req.file.mimetype
      }
    });

  
    stream.on('error', (err) => {
  
      next(err);
  
    });

    stream.on('finish', () => {

      file.makePublic().then(() => {

  
        req.file.cloudStoragePublicUrl = `https://storage.googleapis.com/${GCLOUD_BUCKET}/${oname}`;

  
        next();

      });
    });

  
    stream.end(req.file.buffer);

  }

const Multer = require('multer');
const multer = Multer({
  storage: Multer.MemoryStorage,
  limits: {
    fileSize: 40 * 1024 * 1024
  }
});

module.exports = {
  sendUploadToGCS,
  multer
};
