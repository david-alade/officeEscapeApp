//
//  UploadTaskResponse.swift
//  oneswipe
//
//  Created by David Alade on 6/20/24.
//

import Foundation

enum UploadTaskResponse<T> {
    case progress(Progress)
    case success(T)
}
