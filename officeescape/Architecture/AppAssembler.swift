//
//  AppAssembler.swift
//  bibite
//
//  Created by David Alade on 11/9/23.
//

import Swinject

final class AppAssembler {
    private let assembler: Assembler
    
    var resolver: Resolver {
        self.assembler.resolver
    }
    
    init() {
        self.assembler = Assembler([
            CoordinatorAssembly(),
            ServiceAssembly(),
            ViewModelAssembly()
        ])
    }
}

