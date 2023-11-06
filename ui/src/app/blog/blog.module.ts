import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { BlogPageComponent } from './containers/blog-page/blog-page.component';
import {FormsModule, ReactiveFormsModule} from "@angular/forms";
import {BlogRoutingModule} from "./blog-routing.module";



@NgModule({
  declarations: [
    BlogPageComponent
  ],
  imports: [
    CommonModule,
    FormsModule,
    BlogRoutingModule,
    ReactiveFormsModule
  ]
})
export class BlogModule { }
