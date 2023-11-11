import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
<<<<<<< Updated upstream
=======
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import {MatButtonToggleModule} from '@angular/material/button-toggle';
import { HttpClientModule } from '@angular/common/http';
import {AuthModule} from "@auth0/auth0-angular";
import {CoreModule} from "./core/core.module";
>>>>>>> Stashed changes

@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
<<<<<<< Updated upstream
    BrowserAnimationsModule
=======
    BrowserAnimationsModule,
    FormsModule,
    ReactiveFormsModule,
    MatButtonToggleModule,
    HttpClientModule,

    AuthModule.forRoot({
      domain: 'dev-3nepo87s1vxqfzck.us.auth0.com',
      clientId: 'TEChfij56XrDEOryupXaHL2oH9wnN0mY',
      authorizationParams: {
        redirect_uri: window.location.origin
      }
    }),

    CoreModule
>>>>>>> Stashed changes
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
