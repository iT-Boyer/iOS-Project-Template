//
//  AppError.swift
//  App
//

/// Define app scope error.
enum AppError: LocalizedError {

    /// Simple error object contains a message to display.
    case message(_ message: String)

    var errorDescription: String? {
        switch self {
        case let .message(text):
            return text
        }
    }
}
