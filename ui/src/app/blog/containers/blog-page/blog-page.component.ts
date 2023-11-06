import {Component, OnDestroy, OnInit} from '@angular/core';
import {FormControl} from "@angular/forms";
import {CommentsService} from "../../services/comments.service";
import {ActivatedRoute} from "@angular/router";

@Component({
  selector: 'app-blog-page',
  templateUrl: './blog-page.component.html',
  styleUrls: ['./blog-page.component.scss']
})
export class BlogPageComponent implements OnInit, OnDestroy{
  blog_id: number | undefined;
  comments: any[] = [];
  message: FormControl = new FormControl('');

  constructor(public commentsService: CommentsService, private route: ActivatedRoute) {
  }

  ngOnInit() {
    console.log("HERE")

    // Get blog id from route
    this.blog_id = this.route.snapshot.params['id'] || 1;
    if (this.blog_id) {
      this.connect(this.blog_id);

      // throw new Error('No blog id found');
    }
  }

  connect(blog_id: number) {
    this.commentsService.connect(blog_id).subscribe((comment: any) => {
      this.comments = [...this.comments, comment.message];
    })
  }

  sendMessage() {
    this.commentsService.sendMessage({
      message: this.message.value,
    });
    this.message.setValue('');
  }

  ngOnDestroy() {
    this.commentsService.disconnect();
  }
}
