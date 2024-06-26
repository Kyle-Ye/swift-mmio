//===--------------------------------------------------------------*- h -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#pragma once

#include "Vendor_lldb-enumerations.h"
#include "Vendor_lldb-types.h"

namespace lldb {

class SBError {
public:
  SBError();

  SBError(const lldb::SBError &rhs);

  ~SBError();

  const char* GetCString() const;

  void SetError(uint32_t err, lldb::ErrorType type);

  bool IsValid() const;
};

} // namespace lldb
