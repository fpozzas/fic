<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FavouriteEvent.aspx.cs"
    Inherits="Es.Udc.DotNet.Betbook.Web.Pages.FavouriteEvent" MasterPageFile="~/Betbook.Master" %>

<asp:Content ID="content2" ContentPlaceHolderID="ContentPlaceHolderMain" runat="server">
    <div id="form">
        <form id="AddCommentForm" method="post" runat="server">
        <div class="field">
            <span class="label">
                <asp:Localize ID="lclFavouriteName" runat="server" meta:resourcekey="lclFavouriteName" />
            </span>
            <span class="entry">
                <asp:TextBox ID="txtFavouriteName" runat="server"
                    Width="200px" Columns="16" ></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvFavouriteName" runat="server" ControlToValidate="txtFavouriteName"
                        Display="Dynamic" Text="<%$ Resources: Common, mandatoryField %>" 
                    CssClass="errorMessage"></asp:RequiredFieldValidator>
            </span>

        </div>
        <div class="field">
            <span class="label">
                <asp:Localize ID="lclFavouriteComment" runat="server" meta:resourcekey="lclFavouriteComment" />
            </span>
            <span class="entry">
                <textarea id="txtareaFavouriteComment" runat="server" cols="20" name="S1" rows="4" />
                <asp:RequiredFieldValidator ID="rfvFavouriteComment" runat="server" ControlToValidate="txtareaFavouriteComment"
                        Display="Dynamic" Text="<%$ Resources: Common, mandatoryField %>" 
                    CssClass="errorMessage"></asp:RequiredFieldValidator>
            </span>
        </div>
        <div class="field">
            <asp:Button ID="btnAddFavourite" runat="server" meta:resourcekey="btnAddFavourite" 
                OnClick="btnAddFavourite_Click" />
        </div>
        </form>
    </div>
    <br />
    <br />
</textarea></span></asp:Content>
