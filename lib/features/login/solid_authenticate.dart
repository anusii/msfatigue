/// Solid authenticate method used in MS Fatigue Project.
///
// Time-stamp: <Friday 2025-02-16 12:34:33 +1000 Graham Williams>
///
/// Copyright (C) 2025, Software Innovation Institute, ANU.
///
/// Licensed under the GNU General Public License, Version 3 (the "License").
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html.
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program.  If not, see <https://www.gnu.org/licenses/>.
///
/// Authors: Graham Williams, Zheyuan Xu

library;

import 'package:flutter/material.dart';

import 'package:solidpod/solidpod.dart';
import 'package:solid_auth/solid_auth.dart';

import 'package:solidpod/src/solid/api/rest_api.dart';
import 'package:solidpod/src/solid/utils/authdata_manager.dart'
    show AuthDataManager;
import 'package:solidpod/src/solid/utils/misc.dart' show checkLoggedIn;

// Scopes variables used in the authentication process.

final List<String> _scopes = <String>[
  'openid',
  'profile',
  'offline_access',
  'webid', // web ID is necessary to get refresh token
];

Future<List<dynamic>?> solidAuthenticate(
  String serverId,
  BuildContext context,
) async {
  try {
    final loggedIn = await checkLoggedIn();
    debugPrint('solidAuthenticate() => checkLoggedIn() => $loggedIn');
    Map<dynamic, dynamic>? authData;
    if (loggedIn) {
      authData = await AuthDataManager.loadAuthData();
      assert(authData != null);
    } else {
      debugPrint('solidAuthenticate() => solid_auth.authenticate($serverId)');
      // Authentication process for the POD issuer.

      final issuerUri = await getIssuer(serverId);
      authData = await authenticate(Uri.parse(issuerUri), _scopes, context);

      // write authentication data to flutter secure storage
      await AuthDataManager.saveAuthData(authData);
    }

    final webId = await AuthDataManager.getWebId();
    assert(webId != null);

    final profCardUrl = webId!.replaceAll('#me', '');
    final profData = await fetchPrvFile(profCardUrl);

    return [authData, webId, profData];
  } on Exception catch (e) {
    debugPrint('Solid Authenticate Failed: $e');
    return null;
  }
}
