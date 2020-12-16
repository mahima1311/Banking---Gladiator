import { Component } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { AdminService } from '../admin.service';
import { Admin } from './Models/admin-login.model';
import { RestAdmin } from './Models/rest-admin.model';

@Component({
    selector: 'admin-login',
    templateUrl: 'admin_login.component.html',
    styleUrls: ['./admin_login.component.css']
})

export class AdminLogin{

    loginForm: FormGroup;
    usernameControl: FormControl;
    passwordControl: FormControl;
    invalid:boolean = false;

    constructor(private service:AdminService, formBuilder : FormBuilder, private route: Router){
    
        this.checkSession();
        this.usernameControl = new FormControl("", Validators.required);
        this.passwordControl = new FormControl("", Validators.compose([Validators.required, Validators.minLength(4), Validators.maxLength(40)]));

        this.loginForm = formBuilder.group({
            "username":this.usernameControl,
            "password":this.passwordControl
        });
        
    }

    checkSession(){
        let admin:Admin = JSON.parse(sessionStorage.getItem('admin'));
        console.log(admin);
        if(admin != null || admin != undefined){
            this.router(admin);
        }
    }

    login(frm:any){
        this.invalid = false;
        let username = this.usernameControl.value;
        let password = this.passwordControl.value;
        let restAdminTemplate:RestAdmin;
        this.service.login(username,password).subscribe(
            (data)=>{
                restAdminTemplate = data;
                if(restAdminTemplate.admin != null){
                    console.log("Login Success");
                    this.router(restAdminTemplate.admin);
                }
                else{
                    this.invalid = true;
                }
            }
        );
    }

    saveSession(admin:Admin){
        sessionStorage.setItem('admin', JSON.stringify(admin));
    }

    router(admin:Admin){
        if(admin.role === 'MAIN'){
            this.saveSession(admin);
            this.route.navigate(['/mainAdminDash']);
        }
        else{
            this.saveSession(admin);
            this.route.navigate(['/approveRequestDash']);
            
        }
    }

}