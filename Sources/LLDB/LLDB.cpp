//===------------------------------------------------------------*- c++ -*-===//
//
// This source file is part of the Swift MMIO open source project
//
// Copyright (c) 2024 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

// This file is a TBD style list of symbols which SVD2LLDB requires from
// LLDB.framework. We use the contents of this file to create linker flags to
// which allow these symbols to be undefined when linking. They ultimately are
// provided by the lldb process into which SVD2LLDB is loaded.
//
// This strategy does not work for arm64e, we will deal with that problem later.
//
// This file intentionally has the extension cpp so Swift Package Manager
// considers "LLDB" to be a C++ target.
//
// Important: Updating this file will not trigger SwiftPM to re-determine the
// linker flags the LLDB target so be sure to modify Package.swift after
// modifying this file so the linker flags are actually updated.

#include "LLDB.h"

#include <cstdlib>
#include <cstdio>

#define ABORT {\
  fprintf(stderr, "Invalid use of LLDB stub API %s\n", __FUNCTION__); \
  std::abort(); \
}

using namespace lldb;

// MARK: - SBCommand
SBCommand SBCommand::AddCommand(char const*, SBCommandPluginInterface*, char const*, char const*, char const*) ABORT

// MARK: - SBCommandInterpreter
SBCommand SBCommandInterpreter::AddMultiwordCommand(char const*, char const*) ABORT
SBCommandInterpreter::~SBCommandInterpreter() ABORT

// MARK: - SBCommandReturnObject
void SBCommandReturnObject::PutCString(char const*, int) ABORT
void SBCommandReturnObject::AppendWarning(char const*) ABORT
void SBCommandReturnObject::SetError(char const*) ABORT
SBCommandReturnObject::SBCommandReturnObject(SBCommandReturnObject const&) ABORT
SBCommandReturnObject::~SBCommandReturnObject() ABORT

// MARK: - SBDebugger
SBCommandInterpreter SBDebugger::GetCommandInterpreter() ABORT
SBTarget SBDebugger::GetSelectedTarget() ABORT
SBDebugger::SBDebugger(SBDebugger const&) ABORT
SBDebugger::~SBDebugger() ABORT

// MARK: - SBError
const char* SBError::GetCString() const ABORT
bool SBError::IsValid() const ABORT
void SBError::SetError(unsigned int, ErrorType) ABORT
SBError::SBError(SBError const&) ABORT
SBError::SBError() ABORT
SBError::~SBError() ABORT

// MARK: - SBProcess
size_t SBProcess::ReadMemory(addr_t, void*, size_t, lldb::SBError&) ABORT
size_t SBProcess::WriteMemory(addr_t, const void*, size_t, lldb::SBError&) ABORT
SBProcess::~SBProcess() ABORT

// MARK: - SBTarget
SBProcess SBTarget::GetProcess() ABORT
SBTarget::~SBTarget() ABORT
